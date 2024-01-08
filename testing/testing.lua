local function fmtprint(fmt, ...)
    local s = string.format(fmt, ...)
    print(s)
end


-- Assertion helper.
local assert = {}
assert.is_nil = function(a)
    if a then
        error(string.format("expected %s to be nil", tostring(a)))
    end
end
assert.not_nil = function(a)
    if a == nil then
        error(string.format("expected %s to not be nil", tostring(a)))
    end
end
assert.truthy = function(a)
    if not a then
        error(string.format("expected value to be truthy: %s", tostring(a)))
    end
end
assert.equal = function(a, b)
    if a ~= b then
        error(string.format("expected values to be equal: %s != %s", tostring(a), tostring(b)))
    end
end

local function get_message(err)
    local msg = string.match(err, "^.*:%d+:%s(.*)$")
    if not msg then
        return err
    end
    return msg
end


-- Table containing the registered tests.
local tests = {}

-- Register a function callback as a test.
-- @param name Name of the test. If it already exists, it will be replaced.
-- @param func A parameterless function to run.
local function register(name, func)
    tests[name] = func
end

-- Run all registeried tests and print the results.
-- @param code Call os.exit with the given code if any test failed (default nil).
local function run(code)
    local exit = code or nil

    local status = true
    for name, func in pairs(tests) do
        local success, err = pcall(func)
        if success then
            fmtprint("OK:\t%s", name)
        else
            status = false
            local msg = get_message(err)
            fmtprint("FAIL:\t%s\n\tError: %s", name, msg)
        end
    end

    if code and not status then
        os.exit(exit)
    end
end

return {
    register = register,
    assert = assert,
    run = run,


    
}