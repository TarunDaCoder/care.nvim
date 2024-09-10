local Log = {}

local function write_log(message)
    local file = "./care.log"
    local fd = io.open(file, "a+")
    if not fd then
        error(("Could not open file %s for writing"):format(file))
    end
    fd:write(message .. "\n")
    fd:close()
end

function Log.log(message, ...)
    if not require("care.config").options.debug then
        return
    end

    ---@type any
    local data = { ... }
    if #data == 0 then
        write_log(message)
        return
    elseif #data == 1 then
        data = data[1]
    end

    if type(data) == "string" then
        write_log(message .. ": " .. data)
        return
    elseif type(data) == "function" then
        data = data()
    elseif type(data) == "table" then
        local new = {}
        for key, val in pairs(data) do
            val = type(val) == "string" and val or vim.inspect(val):gsub("%s+", " ")
            table.insert(new, key .. ": " .. val)
        end
        data = table.concat(new, ", ")
    end
    if not data then
        return
    end
    if type(data) ~= "string" then
        data = vim.inspect(data):gsub("%s+", " ")
    end
    write_log(message .. ": " .. data)
end

return Log
