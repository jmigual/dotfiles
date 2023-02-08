
switch (uname -s) 
    case "Linux*"
        # Check if WSL
        if cat /proc/version | grep -qi Microsoft;
            # We are in WSL, start gpg-relay agent
            source "$CUSTOM_SHELL_DIR/gpg-agent-relay2.fish"
        else
            gpgconf --launch gpg-agent
            gpg-connect-agent updatestartuptty /bye
        end
end


