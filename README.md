# zshrc
Base and custom .zshrc files


# Creating a new zshrc

1. `git clone https://github.com/tarjoilija/zgen.git "${HOME}/.zgen"`
2. `git clone THIS_REPO_ADDRESS "${HOME}/.zshrc_base"`
3.
    ```
    cd ${HOME}/.zshrc_base
    cp zshrc_template.sh zshrc_informative_name
    ln -s zshrc_informative_name ${HOME}/.zshrc
    ```