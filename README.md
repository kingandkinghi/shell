# Onboarding
1. Navigate to [Azure/fidalgo-dev](https://github.com/Azure/fidalgo-dev).
2. Create a Codespace:

![Create Codespace](/.img/CreateCodespace.jpg "Click 'Create codespace on main'")

3. Type `CTRL+~` to open a bash bash terminal.
4. Source the shim by executing:
```bash
# load the nix environment
$ . shim.sh
```
5. Follow the onboarding flow.
6. Eventually you should be presented with:
```bash
# dump environment
[PPE 0] $ fd-who
```
# Hello World! 
Make a kusto query. Kusto queries are stored at `/kusto`.
```bash
# dump kusto query
[PPE 0] $ fd-dri-certificate-active

# execute kusto query
[PPE 0] $ fd-dri-certificate-active | fd-kusto-with-headers
```
## Incrementally reproduce a bug in PPE

- Open [`/nix/tst/sh/deply.sh`](/nix/tst/sh/deploy.sh)
- Copy/Paste each line into the shell
  - See [VS Code Configuration](#vs-code-configuration) for key-binding `CTRL+~ DOWN-ARROW` to copy selected text to the bash shell.
```bash
[PPE] $ fd-login-as-administrator
[PPE] $ # next test command...
```
- The last command should fail. Use kusto to get the operation id of the last request.
  - You will need to wait a few minutes for the logs to be published. In the mean time, skip down to running the test in dogfood. You'll need to open a new shell. Click the + in the upper right.
```bash
[PPE] $ fd-dri-search-url ${NIX_ENV_PREFIX}-my-kv-environment | fd-kusto | fd-line-fit

2022-06-08 09:17:11-AM 5017a21f91a322479d4d9f33d2ee0162 PUT
```
- Dump the log trace for a request. Replace the operation id with an operation id taken from the result of the previous query.
```bash
[PPE] $ fd-dri-stack 5017a21f91a322479d4d9f33d2ee0162 | fd-kusto | fd-line-fit | head -n 20
```
## Run the test again in dogfood
- Run test again, but this time in dogfood.
```bash
[PPE] $ fd-switch-to-dogfood
[DOGFOOD] $ fd-login-as-administrator
[DOGFOOD] $ # ...
```
# VS Code Configuration
1. Click on the gear in the lower left to turn on sync.
2. Follow instructions below to enable useful defaults.
```bash
# set default shell environment to bash
vscode > CTRL+SHIFT-P > Terminal: Select Default Profile > Select bash

# save files when the focus changes
vscode > CTRL+, > Save on focus > off -> onFocusChange

# configure useful shell keybindings
vscode > CTRL-SHIFT-P > Preferences: Open Keyboard Shortcuts (JSON) 

# Copy/Paste the below shortcuts to enable:
#   CTRL+` CTRL+` > Open/Close shell toggle
#   CTRL+` UP     > Fullscreen shell toggle
#   CTRL+SHFIT+`  > New shell
#   CTRL+` RIGHT  > Next shell
#   CTRL+` LEFT   > Previous shell
#   CTRL+` DOWN   > Run selected text in shell (super nice)
```
```json
// Place your key bindings in this file to override the defaultsauto[]
[
    {
        "key": "ctrl+` ctrl+`",
        "command": "workbench.action.terminal.toggleTerminal"
    },
    {
        "key": "ctrl+` up",
        "command": "workbench.action.toggleMaximizedPanel"
    },
    {
        "key": "ctrl+` right",
        "command": "workbench.action.terminal.focusNext"
    },
    {
        "key": "ctrl+` left",
        "command": "workbench.action.terminal.focusPrevious"
    },
    {
        "key": "ctrl+` down",
        "command": "workbench.action.terminal.runSelectedText"
    }
]
```
# WSL2
To install CLI on your DevBox open a PowerShell prompt as an administrator:
```
ps> wsl --install
ps> Restart-Computer
```
Install ssh keys per [GitHub instructions](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account) or
```
$ ssh-keygen

$ cat ~/.ssh/id_rsa.pub
# copy to GitHub.com > Settings > SSH Keys + Configure SSO for Azure Org

$ git clone git@github.com:Azure/fidalgo-dev.git
$ cd fidalgo-dev
$ . code
```

# Cloud Test
[CloudTest](https://eng.ms/docs/more/developer-guides/cloudtest-user-guide/cloudtest/what-is-cloudtest) integration. 
# Fidalgo Unix Shell Environment
A non-offical unix environment to support Fidalgo development. 

The shell 
- codifies the environment described in the team **wiki** and **one-note**.
- allows for **sharing kusto queries** in a democratized format (see `/kusto`).
- allows for **sharing http requests templates** ala PostMan (see `/http`).
- provides an environment for **incrementally** running integration tests locally as they are run in the pipeline.
- **eliminates excessive multi-factor authentication** when switching between environments.
- provides an environment for senior developers to **capture and share debug workflows** with junior developers.
- dogfoods Codespaces and DebBox.

# Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit https://cla.opensource.microsoft.com.

When you submit a pull request, a CLA bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., status check, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

# Trademarks

This project may contain trademarks or logos for projects, products, or services. Authorized use of Microsoft 
trademarks or logos is subject to and must follow 
[Microsoft's Trademark & Brand Guidelines](https://www.microsoft.com/en-us/legal/intellectualproperty/trademarks/usage/general).
Use of Microsoft trademarks or logos in modified versions of this project must not cause confusion or imply Microsoft sponsorship.
Any use of third-party trademarks or logos are subject to those third-party's policies.
