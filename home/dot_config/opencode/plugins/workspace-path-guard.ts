import { statSync } from "node:fs"
import { isAbsolute, relative, resolve } from "node:path"
import type { Plugin } from "@opencode-ai/plugin"

/**
 * Detect only an adjacent repetition of the session's workspace root, such as
 * /workspace/charts/workspace/charts. A root mentioned once, including twice
 * as separate source and destination arguments, is intentionally allowed.
 */
export function hasRepeatedWorkspaceRoot(value: string, worktree: string): boolean {
  const normalizedValue = value.replaceAll("\\", "/").replaceAll(/\/{2,}/g, "/")
  const normalizedRoot = worktree.replaceAll("\\", "/").replaceAll(/\/{2,}/g, "/").replace(/\/$/, "")
  if (!normalizedRoot || normalizedRoot === "/") return false

  return normalizedValue.includes(`${normalizedRoot}/${normalizedRoot.slice(1)}`)
}

const errorMessage =
  "Workspace path rejected: use a repository-relative path; paths inside the workspace are not allowed, and absolute workdirs must exist without repeating the workspace root."

export function resolvesInsideWorkspace(value: string, worktree: string): boolean {
  if (!isAbsolute(value)) return false

  const root = resolve(worktree)
  const candidate = resolve(value)
  const relativePath = relative(root, candidate)
  return relativePath === "" || (!relativePath.startsWith("..") && !isAbsolute(relativePath))
}

function absolutePathsInCommand(command: string): string[] {
  return command.match(/(?:[A-Za-z]:[\\/]|\/)[^\s"'`;&|()<>]*/g) ?? []
}

function hasAbsoluteWorkspacePath(value: unknown, worktree: string): boolean {
  return typeof value === "string" && resolvesInsideWorkspace(value, worktree)
}

export default (async ({ directory, worktree }) => {
  return {
    "tool.execute.before": async (input, output) => {
      const args = output.args as { command?: unknown; workdir?: unknown; filePath?: unknown; path?: unknown; pattern?: unknown }
      if (input.tool === "read" || input.tool === "edit") {
        if (hasAbsoluteWorkspacePath(args.filePath, worktree)) throw new Error(errorMessage)
        return
      }
      if (input.tool === "glob") {
        if (hasAbsoluteWorkspacePath(args.path, worktree) || hasAbsoluteWorkspacePath(args.pattern, worktree)) throw new Error(errorMessage)
        return
      }
      if (input.tool === "grep") {
        if (hasAbsoluteWorkspacePath(args.path, worktree)) throw new Error(errorMessage)
        return
      }
      if (input.tool !== "bash") return

      const command = typeof args.command === "string" ? args.command : ""
      const workdir = typeof args.workdir === "string" ? args.workdir : undefined

      if (
        hasRepeatedWorkspaceRoot(command, worktree) ||
        (workdir !== undefined && hasRepeatedWorkspaceRoot(workdir, worktree)) ||
        absolutePathsInCommand(command).some((path) => resolvesInsideWorkspace(path, worktree)) ||
        (workdir !== undefined && hasAbsoluteWorkspacePath(workdir, worktree))
      ) {
        throw new Error(errorMessage)
      }

      // Validate only an explicitly supplied workdir. Relative values are
      // resolved from the hook context's directory, never process.cwd().
      if (Object.prototype.hasOwnProperty.call(args, "workdir")) {
        if (typeof args.workdir !== "string") throw new Error(errorMessage)

        try {
          if (!statSync(resolve(directory, args.workdir)).isDirectory()) throw new Error(errorMessage)
        } catch (error) {
          if (error instanceof Error && error.message === errorMessage) throw error
          throw new Error(errorMessage)
        }
      }
    },
  }
}) satisfies Plugin
