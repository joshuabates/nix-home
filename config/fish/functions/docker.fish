function dshell
    set container (docker ps --format '{{.Names}}' | fzf)
    if test -n "$container"
        docker exec -it $container /bin/bash
    end
end

function drun
    set image (docker images --format '{{.Repository}}:{{.Tag}}' | fzf)
    if test -n "$image"
        docker run -it $image /bin/bash
    end
end
