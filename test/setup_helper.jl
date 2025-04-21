import Pluto: update_save_run!, update_run!, WorkspaceManager, ClientSession,
ServerSession, Notebook, Cell, project_relative_path, SessionActions,
load_notebook, Configuration, set_bond_values_reactive

function noerror(cell; verbose=true)
    if cell.errored && verbose
        @show cell.output.body
    end
    !cell.errored
end

options = Configuration.from_flat_kwargs(; disable_writing_notebook_files=true, workspace_use_distributed_stdlib=true)
srcdir = normpath(@__DIR__, "./notebooks")
eval_in_nb(sn, expr) = WorkspaceManager.eval_fetch_in_workspace(sn, expr)

function set_bond_value_sn(sn)
    (session, notebook) = sn
    function set_bond_value(name, value, is_first_value=false)
        notebook.bonds[name] = Dict("value" => value)
        set_bond_values_reactive(; session, notebook, bound_sym_names=[name],
            is_first_values=[is_first_value],
            run_async=false,
        )
    end
end