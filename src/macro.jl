macro memoized_serialization(key, ex)
    return quote
        begin
            file = joinpath(CACHE_PATH[], string($(esc(key)), ".bin"))

            if isfile(file)
                return Serialization.deserialize(file)
            else
                data = $(esc(ex))
                Serialization.serialize(file, data)
                return data
            end
        end
    end
end
