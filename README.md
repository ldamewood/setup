# setup

My setup for local instances using ansible.

## Quickstart

1. If not already defined, create a file called `secrets` with the following
    vars defined:

    ```yaml
    git_user: ...
    git_email: ...
    git_signing_key: ...
    ansible_become_password: ...
    ```

2. Create a vault password in `.vault-password.txt`
3. Install the desired components

    ```sh
    make setup-git setup-dotfiles setup-osx
    ```

## Future ideas

* Store secrets in external vault.
* Setup Android (and Apple?) devices.
* Start defining specific instances across the network.
    * Use ansible tags and inventories.
* Configure more applications.
* https://galaxy.ansible.com/staticdev/firefox
* https://raw.githubusercontent.com/arkenfox/user.js/master/user.js
