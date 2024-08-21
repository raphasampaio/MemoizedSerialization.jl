macro memoized_serialization(id, ex)
    quote
        file = joinpath(CACHE_PATH[], string($(esc(id)), ".bin"))

        if isfile(file)
            Serialization.deserialize(file)
        else
            data = $(esc(ex))
            Serialization.serialize(file, data)
            data
        end
    end
end
