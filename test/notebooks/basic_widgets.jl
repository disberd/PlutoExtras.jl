### A Pluto.jl notebook ###
# v0.19.29

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ cfb4d354-e0b2-4a04-a559-4fb88df33954
using PlutoDevMacros

# ╔═╡ 57c51c71-fd8d-440d-8262-9cccd1617c08
@frompackage "../.." begin
	using ^
end

# ╔═╡ d9762fc1-fa2c-4315-a360-cc1cd9d70055
md"""
This is an example of `StringOnEnter`: $(@bind text StringOnEnter("ciao"))
"""

# ╔═╡ cbeff2f3-3ffe-4aaa-8d4c-43c44ee6d59f
text === "ciao" || error("Something went wrong")

# ╔═╡ ecfdee44-3e6c-4e7e-a039-1f7d05a875f8
md"""
This is a number: $(@bind num Editable(3))
"""

# ╔═╡ 9a90e5be-6c38-440d-a6d6-99dc25be5727
num === 3 || error("something went wrong")

# ╔═╡ ca6e57a2-667f-4a77-a1ea-5f42192056d4
@bind(
	number_editable,
	Editable(0.5123234; prefix = "Before: ", suffix = " After!", format = ".2f")
)

# ╔═╡ 81c03bad-aed6-4b45-b3b5-edbba30c0bdb
number_editable === 0.5123234 || error("something went wrong")

# ╔═╡ ac83e4d6-1637-4646-865c-7d21ce010374
@bind(
	bool_editable,
	Editable(true)
)

# ╔═╡ 09458943-15a4-4251-82a8-e43299db53b5
bool_editable || error("something went wrong")

# ╔═╡ d171e8f9-c939-4747-a748-5568ae4a4064
num |> typeof

# ╔═╡ 9dfb5236-9475-4bf6-990a-19f8f5519003
md"""
This has also a unit $(@bind unitnum Editable(3.0;suffix=" dB"))
"""

# ╔═╡ 245fad1a-2f1e-4776-b048-6873e8c33f3b
unitnum === 3.0 || error("Something went wrong")

# ╔═╡ 456a3579-3c33-496c-bbf2-6e6e0d0ff102
bool_bond = @bind bool_val Editable(true)

# ╔═╡ 8f7d7dac-d5e6-43f4-88e6-21179c78c3ef
bool_val

# ╔═╡ Cell order:
# ╠═cfb4d354-e0b2-4a04-a559-4fb88df33954
# ╠═57c51c71-fd8d-440d-8262-9cccd1617c08
# ╠═d9762fc1-fa2c-4315-a360-cc1cd9d70055
# ╠═cbeff2f3-3ffe-4aaa-8d4c-43c44ee6d59f
# ╠═ecfdee44-3e6c-4e7e-a039-1f7d05a875f8
# ╠═9a90e5be-6c38-440d-a6d6-99dc25be5727
# ╠═ca6e57a2-667f-4a77-a1ea-5f42192056d4
# ╠═81c03bad-aed6-4b45-b3b5-edbba30c0bdb
# ╠═ac83e4d6-1637-4646-865c-7d21ce010374
# ╠═09458943-15a4-4251-82a8-e43299db53b5
# ╠═d171e8f9-c939-4747-a748-5568ae4a4064
# ╠═9dfb5236-9475-4bf6-990a-19f8f5519003
# ╠═245fad1a-2f1e-4776-b048-6873e8c33f3b
# ╠═456a3579-3c33-496c-bbf2-6e6e0d0ff102
# ╠═8f7d7dac-d5e6-43f4-88e6-21179c78c3ef
