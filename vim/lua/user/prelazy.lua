LAZY_PLUGIN_SPEC = {}

function spec(item)
    table.insert(LAZY_PLUGIN_SPEC, require(item))
end
