-- Get the value if it is not nil, otherwise return the default value.
function getOrDefault(value, defaultIfNil)
    if value == nil then
        return defaultIfNil
    else
        return value
    end
end

-- Check if a value is a table.
function isTable(value)
    return type(value) == "table"
end

-- If the value is a table return it, otherwise create a single element table with the value.
function toTable(value)
    if isTable(value) then
        return value
    end

    return {value}
end

-- Ternary operator shorthand
function ternary(condition, valueIfTrue, valueIfFalse)
    if condition then
        return valueIfTrue
    end

    return valueIfFalse
end