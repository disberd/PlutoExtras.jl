### A Pluto.jl notebook ###
# v0.19.29

using Markdown
using InteractiveUtils

# ╔═╡ 945ee770-e082-11eb-0c8b-25e53f4d718c
begin
	using HypertextLiteral
	using PlutoDevMacros
end

# ╔═╡ 57ec4f3e-ed4d-4c44-af8a-c1e32a3f4bd7
@frompackage "../.." begin
	using ^
end

# ╔═╡ b35233a0-6d2f-4eac-8cb0-e317eef4c835
# ╠═╡ skip_as_script = true
#=╠═╡
md"""
## TeX Equation environment
"""
  ╠═╡ =#

# ╔═╡ a78aa624-6504-4b3f-914a-833261b92f19
initialize_eqref() # This is important for making `eqref(label)` work!

# ╔═╡ b8782294-d6b9-43ac-b745-b2cbb6ed06b1
a = 1:10

# ╔═╡ 0bfb8ee9-14e2-44ee-b0d5-98790d47f7b8
texeq("3+2=5")

# ╔═╡ 958531c1-fa83-477c-be3d-927155800f1b
texeq"
	\sum_{i=$(a[1])}^{$(a[end])} i=$(sum(a)) \label{interactive}
"

# ╔═╡ 1482e175-cf32-42f3-b8fb-64f1f14c1501
md"""
The sum in $(eqref("interactive")) is interactive and its equation number reference automatically updates!
"""

# ╔═╡ 0df86e0e-6813-4f9f-9f36-7badf2f85597
md"""Multiple links to the same equation $(eqref("interactive")) also work! See also $(eqref("seven"))
"""

# ╔═╡ 0bd44757-90b8-452f-999f-6109239ac826
md"""
$(texeq("
3
+
2
"))
"""

# ╔═╡ de8473c1-dea1-4221-9562-30679ae58e34
md"""
$$3+2$$
"""

# ╔═╡ b9213424-f814-4bb8-a05f-33249f4f0a8f
md"""
$(texeq("
	(2 \\cdot 3) + (1 \\cdot 4) &= 6 + 4 \\label{test1} \\\\
	&= 10 \\label{test2} \\\\
	&= 10 \\\\
	&= 10 \\label{test3} \\\\
	&= 10 \\\\
	&= 10 \\label{test4} \\\\
	&= 10 \\\\
	&= 10 \\label{test5}"
,"align"))
"""

# ╔═╡ 9e69e30e-506a-4bd7-b213-0b5c0b31a10d
md"""Link to sub-parts of align environments are now fixed! $(eqref("test1")), $(eqref("test2")), $(eqref("test3")), $(eqref("test4")), $(eqref("test5"))
"""

# ╔═╡ ea09b6ec-8d39-4cd9-9c79-85c1fcce3828
texeq("
	\\begin{align*}
		(2 \\cdot 3) + (1 \\cdot 4) &= 6 + 4 \\
									&= 10
	\\end{align*}
	")

# ╔═╡ 900f494b-690d-43cf-b1b7-61c5d3e68a6d
"\n"

# ╔═╡ 7879d7e3-38ad-4a06-8057-ec30da534d76
texeq("y=2x^2")

# ╔═╡ 9446acfc-a310-4de6-8876-e30ede527e9c
md"""
$$Y = \overline {A} - m \phi (\overline {r} - \gamma \pi)$$
"""

# ╔═╡ 6d750d01-b851-4614-b448-1a6e00fa5754
md"""
$(texeq("
	\\pi =  \\pi^e + \\gamma (P - Y^P) + \\rho \\label{seven}"
))
"""

# ╔═╡ 1471265c-4934-45e3-a4b2-37da94ff7472
md"## Update eqref hyperlinks"

# ╔═╡ b6b08bf0-7282-40b9-ae87-b776a64c519f
md"""
KaTeX [supports](https://katex.org/docs/supported.html) automatic numbering of *equation* environments.
While it does not support equation reference and labelling, [this](https://github.com/KaTeX/KaTeX/issues/2003) hack on github shows how to achieve the label functionality.

Unfortunately, since automatic numbering in KaTeX uses CSS counters, it is not possible to access the value of the counter at a specific DOM element.
We then create a function that loops through all possible katex equation and counts them, putting the relevant number in the appropriate hyperlink innerText to create equation references that automatically update.

The code for the mutationobservers to trigger re-computation of the numbers are taken from the **TableOfContents** in **PlutoUI**
"""

# ╔═╡ d14197d8-cab1-4d92-b81c-d826ea8183f3
# ╠═╡ skip_as_script = true
#=╠═╡
md"""
## TeX equations
"""
  ╠═╡ =#

# ╔═╡ 943e5ef8-9187-4bfd-aefa-8f405b50e6aa
asdasd = 3

# ╔═╡ 2078d2c8-1f38-42fe-9945-b2235e267b38
texeq"
\frac{q \sqrt{2}}{15} + $(3 + 2 + (5 + 32)) - $asdasd
"

# ╔═╡ 2c82ab99-8e86-41c6-b938-3635d2d3ccde
md"""
The antenna pattern of a DRA antenna can at first approximation be expressed as:
$(texeq("3+2"))
"""

# ╔═╡ Cell order:
# ╠═945ee770-e082-11eb-0c8b-25e53f4d718c
# ╠═57ec4f3e-ed4d-4c44-af8a-c1e32a3f4bd7
# ╟─b35233a0-6d2f-4eac-8cb0-e317eef4c835
# ╠═a78aa624-6504-4b3f-914a-833261b92f19
# ╠═b8782294-d6b9-43ac-b745-b2cbb6ed06b1
# ╠═0bfb8ee9-14e2-44ee-b0d5-98790d47f7b8
# ╠═958531c1-fa83-477c-be3d-927155800f1b
# ╠═1482e175-cf32-42f3-b8fb-64f1f14c1501
# ╠═0df86e0e-6813-4f9f-9f36-7badf2f85597
# ╠═0bd44757-90b8-452f-999f-6109239ac826
# ╠═de8473c1-dea1-4221-9562-30679ae58e34
# ╠═b9213424-f814-4bb8-a05f-33249f4f0a8f
# ╠═9e69e30e-506a-4bd7-b213-0b5c0b31a10d
# ╠═ea09b6ec-8d39-4cd9-9c79-85c1fcce3828
# ╠═900f494b-690d-43cf-b1b7-61c5d3e68a6d
# ╠═7879d7e3-38ad-4a06-8057-ec30da534d76
# ╠═9446acfc-a310-4de6-8876-e30ede527e9c
# ╠═6d750d01-b851-4614-b448-1a6e00fa5754
# ╟─1471265c-4934-45e3-a4b2-37da94ff7472
# ╟─b6b08bf0-7282-40b9-ae87-b776a64c519f
# ╟─d14197d8-cab1-4d92-b81c-d826ea8183f3
# ╠═2078d2c8-1f38-42fe-9945-b2235e267b38
# ╠═943e5ef8-9187-4bfd-aefa-8f405b50e6aa
# ╠═2c82ab99-8e86-41c6-b938-3635d2d3ccde
