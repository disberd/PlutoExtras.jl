### A Pluto.jl notebook ###
# v0.14.8

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ 57c51c71-fd8d-440d-8262-9cccd1617c08
md"""
# Editable Object
"""

# ╔═╡ d9762fc1-fa2c-4315-a360-cc1cd9d70055
md"""
Create an element inspired by (and almost equivalent to) the Scrubbable from PlutoUI but with the possibility of changing the value by clicking on the number and editing the value
"""

# ╔═╡ 30f5eecc-f9bc-48e9-adb0-628e856bc085
md"""
### Examples
"""

# ╔═╡ a1be6790-c932-11eb-0b3a-23cc77d240e9
begin
	Base.@kwdef struct Editable
		default::Real
		format::Union{AbstractString,Nothing}=nothing
		prefix::AbstractString=""
		suffix::AbstractString=""
	end
	Editable(x::Number; kwargs...) = Editable(; default=x, kwargs...)
	
	Base.get(s::Editable) = s.default
	
	function Base.show(io::IO, m::MIME"text/html", s::Editable)
		format = if s.format === nothing
			# TODO: auto format
			if eltype(s.default) <: Integer
				""
			else
				".4~g"
			end
		else
			String(s.format)
		end

		write(io, """
        
        <script>

			const d3format = await import("https://cdn.jsdelivr.net/npm/d3-format@2/+esm")

			const elp = html`
			<span style="
			touch-action: none;
			background: rgb(252, 209, 204);
			padding: 0em .2em;
			border-radius: .3em;
			font-weight: bold;">$((s.prefix))<span contentEditable=true>$(s.default)</span>$((s.suffix))</span>
			`

			const formatter = s => d3format.format($(repr(format)))(s)
            const el = elp.querySelector("span")

			// initial value
			el.innerText = formatter($(s.default))
            elp.value = parseFloat($(s.default))

            const onBlur = (e) => {
                if (el.innerText === "") {
                    elp.value = $(s.default)   
                } else {
                    elp.value =  parseFloat(el.innerText)
                }
                el.innerText = formatter(elp.value)
                elp.dispatchEvent(new CustomEvent("input"))
            }

            // Function to blur the element when pressing enter instead of adding a newline
            const onEnter = (e) => {
                if (e.keyCode === 13) {
                    e.preventDefault();
                    el.blur()
                }
            }

            el.addEventListener('keydown',onEnter)
            el.addEventListener('blur',onBlur)

			// el.onselectstart = () => false

            return elp
			</script>""")
	end
	
	Editable
end;

# ╔═╡ cbeff2f3-3ffe-4aaa-8d4c-43c44ee6d59f
export Editable

# ╔═╡ ecfdee44-3e6c-4e7e-a039-1f7d05a875f8
md"""
This is a number: $(@bind num Editable(3))
"""

# ╔═╡ d171e8f9-c939-4747-a748-5568ae4a4064
num

# ╔═╡ 9dfb5236-9475-4bf6-990a-19f8f5519003
md"""
This has also a unit $(@bind unitnum Editable(3.0;suffix=" dB"))
"""

# ╔═╡ 245fad1a-2f1e-4776-b048-6873e8c33f3b
unitnum

# ╔═╡ Cell order:
# ╟─57c51c71-fd8d-440d-8262-9cccd1617c08
# ╟─d9762fc1-fa2c-4315-a360-cc1cd9d70055
# ╠═cbeff2f3-3ffe-4aaa-8d4c-43c44ee6d59f
# ╟─30f5eecc-f9bc-48e9-adb0-628e856bc085
# ╟─ecfdee44-3e6c-4e7e-a039-1f7d05a875f8
# ╠═d171e8f9-c939-4747-a748-5568ae4a4064
# ╟─9dfb5236-9475-4bf6-990a-19f8f5519003
# ╠═245fad1a-2f1e-4776-b048-6873e8c33f3b
# ╠═a1be6790-c932-11eb-0b3a-23cc77d240e9
