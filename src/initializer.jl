function __init__()
    if isdir(PATH)
        rm(PATH; force = true, recursive = true)
    end
    return nothing
end
