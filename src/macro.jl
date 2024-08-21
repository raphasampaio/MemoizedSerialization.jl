macro serializer_cache(id, ex)
    quote
        begin
            if !isdir(PATH)
                mkdir(PATH)
            end

            file = joinpath(PATH, string($(esc(id)), ".bin"))

            if isfile(file)
                Serialization.deserialize(file)
            else
                data = $(esc(ex))
                Serialization.serialize(file, data)
                data
            end
        end
    end
end