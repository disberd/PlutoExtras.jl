# This function is an internal helper that returns just the letters (without numbers and dashes) of the currently running cell id. Returns a random string of 10 letters in case the currently running cell id can not be parsed. Mostly used to produce consistent ids for javascript scripts in Pluto
function cell_id_letters(limit = 10)
    fallback = String(rand('a':'z', 10))
    isdefined(Main, :PlutoRunner) || return fallback
    isdefined(Main.PlutoRunner, :currently_running_cell_id) || return fallback
    ref = Main.PlutoRunner.currently_running_cell_id
    (ref isa Ref && isassigned(ref)) || return fallback
    uuid = ref[]
    # Return up to `limit` characters
    str = replace(string(uuid), r"[\d-]" => "")
    return first(str, limit)
end