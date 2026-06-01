-- lua/config/plugins/jdtls.lua
-- NixOS: jdtls comes from Nix (jdt-language-server in modules/home/dev.nix).
-- The Nix `jdtls` wrapper already handles the Java invocation, the equinox
-- launcher jar, and the platform config dir — so the whole OS-detection /
-- launcher-jar-glob / java-binary-resolution dance from the Mason version is
-- gone. We just call `jdtls -data <workspace>`.
return {
	"mfussenegger/nvim-jdtls",
	ft = "java",
	config = function()
		local function setup_jdtls()
			local jdtls = require("jdtls")

			local root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" })
			local project_name = vim.fn.fnamemodify(root_dir or vim.fn.getcwd(), ":p:h:t")
			local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. project_name

			local config = {
				cmd = { "jdtls", "-data", workspace_dir },
				root_dir = root_dir,

				settings = {
					java = {
						eclipse = {
							downloadSources = true,
						},
						configuration = {
							updateBuildConfiguration = "interactive",
						},
						maven = {
							downloadSources = true,
						},
						implementationsCodeLens = {
							enabled = true,
						},
						referencesCodeLens = {
							enabled = true,
						},
						references = {
							includeDecompiledSources = true,
						},
						format = {
							enabled = true,
							settings = {
								tabSize = 2,
								insertSpaces = true,
							},
						},
					},
					signatureHelp = { enabled = true },
					completion = {
						favoriteStaticMembers = {
							"org.hamcrest.MatcherAssert.assertThat",
							"org.hamcrest.Matchers.*",
							"org.hamcrest.CoreMatchers.*",
							"org.junit.jupiter.api.Assertions.*",
							"java.util.Objects.requireNonNull",
							"java.util.Objects.requireNonNullElse",
						},
					},
					sources = {
						organizeImports = {
							starThreshold = 9999,
							staticStarThreshold = 9999,
						},
					},
					codeGeneration = {
						toString = {
							template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
						},
						useBlocks = true,
					},
				},

				init_options = {
					bundles = {},
				},

				capabilities = require("blink.cmp").get_lsp_capabilities(),
			}

			jdtls.start_or_attach(config)
		end

		vim.api.nvim_create_autocmd("FileType", {
			pattern = "java",
			callback = setup_jdtls,
		})
	end,
}
