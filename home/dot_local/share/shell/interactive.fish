
switch (uname -s) 
    case "Linux*"
        # Check if WSL
        if cat /proc/version | grep -qi Microsoft;
            # We are in WSL, start gpg-relay agent
            # $HOME/.local/bin/gpg-agent-relay start
            source "$CUSTOM_SHELL_DIR/gpg-agent-relay2.fish"
        else
            gpgconf --launch gpg-agent
            gpg-connect-agent updatestartuptty /bye
        end
end


