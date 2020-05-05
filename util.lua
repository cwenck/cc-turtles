function findSlotWithItem(item)

end

function selectSlotWithItem(item)
    local slot = findSlotWithItem(item)
    turtle.select(slot)
end

function getOrDefault(var, defaultIfNil)
    if var == nil then
        return defaultIfNil
    else
        return var
    end
end