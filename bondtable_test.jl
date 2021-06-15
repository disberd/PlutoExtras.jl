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

# ╔═╡ df10bb60-ca8c-11eb-0788-af4eb2ef9fa1
begin
	using HypertextLiteral: @htl, @htl_str
	using PlutoUtils
end

# ╔═╡ 662b8f7f-3dee-4ad1-806a-3accbcfc7209
T = NamedTuple{(:idx, Symbol("A <Value>")), Tuple{Int64, String}};

# ╔═╡ d5ac916b-1b4e-40d8-a0f0-55fd39e6b110
database = [T((1, "A&B"))];

# ╔═╡ bde2d117-d98b-4260-87d1-3d6652f6d0d1
asd_bond = @bind asd Editable(3,suffix=" W/GHz")

# ╔═╡ d8cb6bfe-46fb-4848-bb80-9075dfb38c32
dict = Dict("Gesu cristo" => 5,"Re" => asd_bond)

# ╔═╡ 12b0602c-ca32-4102-8cfa-cedc54b9144d
dict2 = Dict("Gesu cristo" => 5,"Re" => asd_bond, "Madonna" => asd_bond);

# ╔═╡ 3e00443f-cf89-44bb-aca8-5e9248be181d
fields = T.parameters[1]

# ╔═╡ c349bb9f-3cd5-4ca8-8236-80c91089e41a
head = @htl("""
	<tr><th colspan="2"> Test
	<tr>$([@htl("<th>$x") for x in fields])
	""")

# ╔═╡ 9cdbdb8d-8db2-4d5f-bc4c-348f1e78f66f
head2 = @htl("""
	<tr><th colspan="2"> Parameters Of This Jesus Christ
	<tr><th>Name <th>Value
	""")

# ╔═╡ 25f485fe-d297-4cc7-884d-f62ab0a310a3
@htl("<table>$head2</table")

# ╔═╡ 6ac745a3-0ad6-45d1-9d14-0597eb525c69
row_template = """
	<tr>$(join(["<td>\$(row[$(repr(x))])" for x in fields]))
"""

# ╔═╡ 4ab920f5-16f4-4081-a970-7566a0f36801
row_template2 = """
	<tr><td>\$(row.first)<td>\$(row.second)
"""

# ╔═╡ fa010756-a78d-422d-8aee-45172d4b0f88
eval(:(tablerow(row) = @htl_str $row_template))

# ╔═╡ b766170a-3c1a-434c-bcdb-e410ded47994
eval(:(tablepair(row) = @htl_str $row_template2))

# ╔═╡ 3a84b92f-f03e-4bba-ae70-ab20259f3ff6
for p ∈ pairs(dict)
	println(tablepair(p))
end

# ╔═╡ bd076fea-f412-4639-aa4f-cd0d46719afa
table_template = "<table>$head\$([tablerow(row) for row in data])</table>"

# ╔═╡ af7626a5-fa72-4324-a849-24d542e83ec7
table_template2 = """
<table style="padding: 3em">$head2\$([tablepair(p) for p in pairs(data)])</table>
"""

# ╔═╡ 4e08e8f0-36d9-4ad8-8775-5e790cf92a69
eval(:(print_table(data) = @htl_str $table_template))

# ╔═╡ fef577c2-815a-462e-badc-778a26161d5e
eval(:(print_table2(data) = @htl_str $table_template2))

# ╔═╡ ba5b6a92-df94-4c0c-996e-c37c3df0756c
asd_bond.defines

# ╔═╡ 74fffa85-42fc-48ab-a5ee-292fa44586fd
td = print_table2(dict)

# ╔═╡ 23e20d3e-508d-4534-a5b5-3dff0023ccaf
@htl("""
	$td $(print_table2(dict2))
	<script>
		let div = currentScript.parentElement
		div.style.display = "flex"
	""")

# ╔═╡ 1185583b-6d6f-44af-8224-c27acdddddf4
function parameters_table(dict;head_name="Parameters",kwargs...)
	# Define the header of the table
	head = @htl("""
	<tr><th colspan="2"> $head_name
	<tr><th>Name <th>Value
	""")
	
	# Define the template to be used for each pair of keys-vals in the dict, which will represent a separate row
	row_template = "<tr><td>\$(pair.first)<td>\$(pair.second)"
	
	# Create the function to process the rows
	eval(:(tablerow(pair) = @htl_str $row_template))
	
	# Define the string template for the whole table
	table_template = """
	<table style="padding: 3em">$head\$([tablerow(p) for p in pairs(dict)])</table>
"""
	# Create the function to generate the table
	eval(:(print_table(dict) = @htl_str $table_template))
	
	print_table(dict)
end

# ╔═╡ b2aa852e-5572-49a1-bc76-9ae0e51ad3bd
parameters_table(dict2)

# ╔═╡ 517a6017-5413-4716-9ca6-af0b685e0043
begin
	power_bonds = let
		dict = Dict{String,Main.PlutoRunner.Bond}()
		## OBP bonds
		dict["OBP W per GHz"] = @bind OBP_noBFN_ppGHz Editable(2,suffix=" W/GHz")
		dict["DBFN W per GHz"] = @bind OBP_DBFN_ppGHz Editable(0.006,suffix=" W/GHz")
		dict
	end
	power_bonds_table = parameters_table(power_bonds)
end;

# ╔═╡ 68d784dc-2594-454e-aee8-3f78b08e4d70
power_bonds_table

# ╔═╡ ab2f37c2-aaae-4f5b-8dad-cd92aa36bbf6
print_table(database)

# ╔═╡ ea7486f0-6a4e-4f18-bcfa-efaa29eefbcb
a = @htl("""
  <tr>
    <th colspan="2">Mars
    <th colspan="2">Venu
  </tr>
  <tr>
    <th scope="col">Produced</th>
    <th scope="col">Sold</th>
    <th scope="col">Produced</th>
    <th scope="col">Sold</th>
  </tr>
	""")

# ╔═╡ 6d4b494d-de21-4cac-9d10-2c989a50d228
@htl("<table>$a</table")

# ╔═╡ Cell order:
# ╠═df10bb60-ca8c-11eb-0788-af4eb2ef9fa1
# ╠═662b8f7f-3dee-4ad1-806a-3accbcfc7209
# ╠═d5ac916b-1b4e-40d8-a0f0-55fd39e6b110
# ╠═bde2d117-d98b-4260-87d1-3d6652f6d0d1
# ╠═d8cb6bfe-46fb-4848-bb80-9075dfb38c32
# ╠═12b0602c-ca32-4102-8cfa-cedc54b9144d
# ╠═3e00443f-cf89-44bb-aca8-5e9248be181d
# ╠═c349bb9f-3cd5-4ca8-8236-80c91089e41a
# ╠═9cdbdb8d-8db2-4d5f-bc4c-348f1e78f66f
# ╠═25f485fe-d297-4cc7-884d-f62ab0a310a3
# ╠═6ac745a3-0ad6-45d1-9d14-0597eb525c69
# ╠═4ab920f5-16f4-4081-a970-7566a0f36801
# ╠═fa010756-a78d-422d-8aee-45172d4b0f88
# ╠═b766170a-3c1a-434c-bcdb-e410ded47994
# ╠═3a84b92f-f03e-4bba-ae70-ab20259f3ff6
# ╠═bd076fea-f412-4639-aa4f-cd0d46719afa
# ╠═af7626a5-fa72-4324-a849-24d542e83ec7
# ╠═4e08e8f0-36d9-4ad8-8775-5e790cf92a69
# ╠═fef577c2-815a-462e-badc-778a26161d5e
# ╠═ba5b6a92-df94-4c0c-996e-c37c3df0756c
# ╠═74fffa85-42fc-48ab-a5ee-292fa44586fd
# ╠═23e20d3e-508d-4534-a5b5-3dff0023ccaf
# ╠═b2aa852e-5572-49a1-bc76-9ae0e51ad3bd
# ╠═1185583b-6d6f-44af-8224-c27acdddddf4
# ╠═517a6017-5413-4716-9ca6-af0b685e0043
# ╠═68d784dc-2594-454e-aee8-3f78b08e4d70
# ╠═ab2f37c2-aaae-4f5b-8dad-cd92aa36bbf6
# ╠═ea7486f0-6a4e-4f18-bcfa-efaa29eefbcb
# ╠═6d4b494d-de21-4cac-9d10-2c989a50d228
