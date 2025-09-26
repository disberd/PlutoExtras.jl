@testsnippet setup_combinehtl begin
    using Test
    using PlutoExtras.PlutoCombineHTL.WithTypes
    using PlutoExtras.PlutoCombineHTL: LOCAL_MODULE_URL
    using PlutoExtras.HypertextLiteral
    using PlutoExtras.PlutoCombineHTL: shouldskip, children, print_html,
    script_id, inner_node, plutodefault, haslisteners, is_inside_pluto, hasreturn,
    add_pluto_compat, hasinvalidation, displaylocation, returned_element, to_string,
    formatted_contents
    import PlutoExtras
    using PlutoExtras.PlutoCombineHTL.AbstractPlutoDingetjes.Display
end

@testitem "make_script" setup=[setup_combinehtl] begin
    ds = make_script("test")
    @test make_script(ds) === ds
    @test ds isa DualScript
    @test inner_node(ds, InsidePluto()).body == inner_node(ds, OutsidePluto()).body
    @test ds.inside_pluto.body.content === "test"
    ds = make_script("lol"; id = "asdfasdf")
    @test script_id(ds, InsidePluto()) === "asdfasdf"
    @test script_id(ds, OutsidePluto()) === "asdfasdf"
    ds2 = make_script(
        make_script(:pluto; body = "lol", id = "asdfasdf"),
        make_script(:normal; body = "lol", id = "different"),
    )
    @test ds.inside_pluto == ds2.inside_pluto
    @test ds.outside_pluto != ds2.outside_pluto

    @test shouldskip(ScriptContent()) === true
    @test ScriptContent(nothing) === missing
    @test ScriptContent(missing) === missing
    sc = ScriptContent("addScriptEventListeners('lol')")
    @test sc.addedEventListeners === true
    sc = ScriptContent("console.log('lol')")
    @test sc.addedEventListeners === false


    @test_logs (:warn, r"No <script> tag was found") make_script(;invalidation = @htl("lol"))
    @test_logs (:warn, r"More than one <script> tag was found") make_script(@htl("""
    <script id='lol'>asd</script>
    <script class='asd'></script>
    """))
    @test_logs (:warn, r"The provided input also contained contents outside") make_script(@htl("""
    <script id='lol'>asd</script>
    magic
    """))
    @test_throws "No closing </script>" make_script(@htl("<script>asd"))
    ds = make_script(;invalidation = @htl("lol"))
    @test shouldskip(ds, InsidePluto()) && shouldskip(ds, OutsidePluto()) # The script is empty because with `@htl` we only get the content between the first <script> tag.
    ds = make_script(;invalidation = "lol")
    @test shouldskip(ds, InsidePluto()) === false
    ds = make_script(;invalidation = @htl("<script>lol</script>"))
    @test !shouldskip(ds, InsidePluto())
    @test shouldskip(ds, OutsidePluto())
    @test shouldskip(ds.inside_pluto.body)
    @test ds.inside_pluto.invalidation.content === "lol"

    ps = PlutoScript("asd", "lol")
    @test PlutoScript(ps) === ps
    @test ps.body.content === "asd"
    @test ps.invalidation.content === "lol"
    @test shouldskip(ps, InsidePluto()) === false
    @test shouldskip(ps, OutsidePluto()) === true

    ns = NormalScript("lol")
    @test NormalScript(ns) === ns
    @test_throws "You can't construct" NormalScript(ps).body

    let ds = DualScript(ps)
        @test ds.inside_pluto === ps
        @test shouldskip(ds, OutsidePluto())
    end
    let ds = DualScript(ns)
        @test ds.outside_pluto === ns
        @test shouldskip(ds, InsidePluto())
    end

    cs = make_script([
        "asd",
        "lol",
    ])
    @test !(hasreturn(cs, InsidePluto()) || hasreturn(cs, OutsidePluto()))
    @test hasinvalidation(cs) === false
    @test add_pluto_compat(cs) === true
    @test cs isa CombinedScripts
    @test CombinedScripts(cs) === cs
    @test make_script(cs) === cs
    @test script_id(cs, InsidePluto()) isa String
    @test children(CombinedScripts(ds)) == children(make_script([ds]))

    @test isempty(children(make_script([PlutoScript("asd")]))) === false
    @test isempty(children(make_script([NormalScript("asd")]))) === false

    make_script(ShowWithPrintHTML(cs)) === cs
    @test_throws "only valid if `T <: Script`" make_script(ShowWithPrintHTML("asd"))

    # Now we test that constructing a CombinedScripts with a return in not the last script or more returns errors.
    ds1 = make_script(PlutoScript(;returned_element = "asd"))
    ds2 = make_script("asd")

    @test_throws "More than one return" make_script([
        ds1,
        ds2,
        ds1,
    ])
    ds3 = make_script(PlutoScript(;returned_element = "asd"), NormalScript(;returned_element = "boh"))
    cs = make_script([
        ds2,
        ds3
        ]; returned_element = "lol"
    )
    @test returned_element(cs, InsidePluto()) === "lol"
    @test returned_element(cs, OutsidePluto()) === "lol"
    @test returned_element(ds3, InsidePluto()) === "asd"
    @test returned_element(ds3, OutsidePluto()) === "boh"

    cs = make_script([
        PrintToScript(3)
    ]; returned_element = "asd")
    @test last(children(cs)).el isa DualScript

    @test make_script(:outside, ds2) === ds2.outside_pluto
    @test make_script(:Inside, ds2) === ds2.inside_pluto

    pts = PrintToScript(3)
    @test make_script(pts) === pts
    @test make_node(pts) isa CombinedScripts
    
    @test PrintToScript(pts) === pts
    @test_throws "You can't wrap" PrintToScript(PlutoNode("asd"))
    
    pts = PrintToScript("asd")
    @test pts.el isa DualScript
    @test script_id(pts, InsidePluto()) isa String
end

@testitem "make_node" setup=[setup_combinehtl] begin
    dn = make_node()
    @test dn isa DualNode
    @test shouldskip(dn, InsidePluto()) && shouldskip(dn, OutsidePluto())

    s = make_script("asd")
    dn = make_node("asd")
    @test make_node(s) === s
    @test dn != s
    @test make_node(dn) === dn
    cn = make_node([
        "asd",
        "",
        "lol"
    ])
    @test cn isa CombinedNodes
    @test CombinedNodes(cn) === cn
    @test length(children(cn)) === 2 # We skipped the second empty element
    @test make_node(cn) === cn

    cn = CombinedNodes(dn)
    dn_test = cn.children[1].el
    @test dn_test == dn

    @test PlutoNode(dn.inside_pluto) === dn.inside_pluto
    @test PlutoNode(@htl("")).empty === true

    nn = NormalNode("lol")
    dn = DualNode(nn)
    @test inner_node(dn, OutsidePluto()) === nn
    @test shouldskip(dn, InsidePluto())

    pn = PlutoNode("asd")
    dn = DualNode(pn)
    @test inner_node(dn, InsidePluto()) === pn
    @test shouldskip(dn, OutsidePluto())
    @test shouldskip(dn, InsidePluto()) === false


    dn = DualNode("asd", "lol")
    @test inner_node(dn, InsidePluto()) == pn
    @test inner_node(dn, OutsidePluto()) == nn
    @test DualNode(dn) === dn

    function compare_content(n1, n2; pluto = missing)
        io1 = IOBuffer()
        io2 = IOBuffer()
        print_html(io1, n1; pluto = pluto === missing ? plutodefault(n1) : pluto)
        print_html(io2, n2; pluto = pluto === missing ? plutodefault(n2) : pluto)
        String(take!(io1)) == String(take!(io2))
    end
    
    @test compare_content(make_node(HTML("asd")), make_node("asd"))
    @test compare_content(NormalNode("asd"), NormalNode(ShowWithPrintHTML("asd")))
    @test compare_content(PlutoNode("asd"), NormalNode("asd"))
    @test compare_content(PlutoNode("asd"), NormalNode("asd"); pluto = true) === false
    @test compare_content(PlutoNode("asd"), NormalNode("asd"); pluto = false) === false

    function test_stripping(inp, expected)
        dn = make_node(inp)
        pn = inner_node(dn, InsidePluto())
        io = IOBuffer()
        print_html(io, pn)
        s = String(take!(io))
        s === expected
    end

    @test test_stripping("\n\n  a\n\n","  a\n") # Only leading newlines (\r or \n) are removed
    @test test_stripping("\n\na  \n\n","a\n") # Only leading newlines (\r or \n) are removed
    @test test_stripping(@htl("lol"), "lol\n")
    @test test_stripping(@htl("
    lol
    
    "), "    lol\n") # lol is right offset by 4 spaces

    
    @test isempty(children(make_node([PlutoNode("asd")]))) === false
    @test isempty(children(make_node([NormalNode("asd")]))) === false

    @test make_node(:pluto, "asd") === PlutoNode("asd")
    @test make_node(:outside; content = "lol") === NormalNode("lol")
    @test make_node(:both, "asd", "lol") === DualNode("asd", "lol")
    @test make_node(:both, "asd", "lol") === make_node("asd", "lol")
end

@testitem "Other Helpers" setup=[setup_combinehtl] begin
    @test shouldskip(3) === false
    s = make_html(PlutoScript())
    @test s isa ShowWithPrintHTML
    @test make_html(s) === s
    for T in (HypertextLiteral.Render, HypertextLiteral.Bypass)
        @test shouldskip(T("lol")) === false
        @test shouldskip(T("")) === true
    end

    # We should not skip a script it is empty content but with an id
    @test shouldskip(PlutoScript(""), InsidePluto()) == true
    @test shouldskip(PlutoScript(""; id = "lol"), InsidePluto()) == false
    @test shouldskip(NormalScript(""; id = "lol"), OutsidePluto()) == false
    ds = DualScript(""; id = "lol")
    @test shouldskip(ds, InsidePluto()) == shouldskip(ds, OutsidePluto()) == false

    for l in (InsidePluto(), OutsidePluto())
        @test haslisteners(make_script("asd"), l) === false
    end
    s = "addScriptEventListeners('lol')"
    @test haslisteners(make_script(s, "asd"), InsidePluto()) === true
    @test haslisteners(make_script(s, "asd"), OutsidePluto()) === false
    @test haslisteners(missing) === false

    @test_throws "can not identify a display location" displaylocation(:not_exist)

    @test hasreturn(make_script("asd","lol"), InsidePluto()) === false
    @test hasreturn(make_script("asd","lol"), OutsidePluto()) === false
    ds = make_script(PlutoScript(; returned_element = "asd"),"lol")
    @test shouldskip(ds.inside_pluto) === false
    @test hasreturn(ds, InsidePluto()) === true
    @test hasreturn(ds, OutsidePluto()) === false
    @test hasreturn(make_script(NormalScript(;returned_element = "lol")), OutsidePluto()) === true
    @test hasreturn(make_script(NormalScript(;returned_element = "lol")), InsidePluto()) === false

    cs = make_script([
        "asd",
        "lol",
    ])
    cn = make_node([
        "asd",
        "lol",
    ])
    # Test getproperty
    @test cs.children === children(cs)
    @test cn.children === children(cn)

    # We test the abstract type constructors
    @test Script(InsideAndOutsidePluto()) === DualScript
    @test Script(InsidePluto()) === PlutoScript
    @test Script(OutsidePluto()) === NormalScript

    @test Node(InsideAndOutsidePluto()) === DualNode
    @test Node(InsidePluto()) === PlutoNode
    @test Node(OutsidePluto()) === NormalNode

    ps = PlutoScript("asd")
    ns = NormalScript("asd")
    ds = make_script(ps,ns)
    @test DualScript("asd") == ds
    @test_throws "can't construct" PlutoScript(ns)
    @test_throws "can't construct" NormalScript(ps)

    @test PlutoScript(ds) === ps
    @test NormalScript(ds) === ns

    for D in (InsidePluto, OutsidePluto, InsideAndOutsidePluto)
        @test plutodefault(D) === plutodefault(D())
        @test displaylocation(D()) === D()
    end
    io = IOBuffer()
    swp1 = ShowWithPrintHTML(make_node("asd"); display_type = :pluto)
    swp2 = ShowWithPrintHTML(make_node("asd"); display_type = :both) # :both is the default
    @test plutodefault(io, swp1) === plutodefault(swp1)
    @test plutodefault(io, swp2) === is_inside_pluto(io) !== plutodefault(swp1)

    @test displaylocation(PrintToScript(3)) === InsideAndOutsidePluto()
    @test displaylocation(PrintToScript(PlutoScript("asd"))) === InsidePluto()

    swph = ShowWithPrintHTML(3)
    @test PlutoCombineHTL._eltype(swph) === Int
    @test shouldskip(swph, InsidePluto()) === false

    swph = ShowWithPrintHTML(3; display_type = :outside)
    @test shouldskip(swph, InsidePluto()) === true

    @test add_pluto_compat(3) === false
    @test hasinvalidation(3) === false

    @test haslisteners(PrintToScript(3)) === false
    @test hasreturn(PrintToScript(3)) === false

    @test script_id(PlutoScript("asd"), OutsidePluto()) === missing
    pts = PrintToScript(3)
    @test script_id(pts) === missing

    @test_throws "You can't wrap object" ShowWithPrintHTML(PrintToScript(3))
end

@testitem "Show methods" setup=[setup_combinehtl] tags=[:before] begin
    ps = PlutoScript("asd", "lol")
    s = to_string(ps, MIME"text/javascript"())
    hs = to_string(ps, MIME"text/html"())
    @test contains(s, r"JS Listeners .* PlutoExtras") === false # No listeners helpers should be added
    @test contains(s, "invalidation.then(() => {\nlol") === true # Test that the invaliation script is printed
    @test contains(hs, r"<script id='\w+'") === true

    struct ASD end
    function PlutoCombineHTL.print_javascript(io::IO, ::ASD; pluto)
        if pluto
            println(io, "ASD_PLUTO")
        else
            println(io, "ASD_NONPLUTO")
        end
    end

    cs = make_script([ASD() |> PrintToScript])
    s_in = to_string(cs, MIME"text/javascript"(); pluto = true)
    s_out = to_string(cs, MIME"text/javascript"(); pluto = false)
    @test contains(s_in, "ASD_PLUTO")
    @test contains(s_out, "ASD_NONPLUTO")

    struct LOL end
    function PlutoCombineHTL.print_javascript(io::IO, ::LOL; pluto)
        if pluto
            show(io, MIME"text/javascript"(), published_to_js(3))
            println(io)
        else
            println(io, "LOL_NONPLUTO")
        end
    end

    # We test that the custom struct wrapped with PrintToScript is not also being printed as invalidaion
    cs = CombinedScripts([
        PrintToScript(LOL())
        PlutoScript("asd","lol")    
    ]) 
    s_in = to_string(cs, print_javascript; pluto = true)
    @test length(findall("published object on Pluto", s_in)) == 1

    ds = DualScript("addScriptEventListeners('lol')", "magic"; id = "custom_id")
    s_in = to_string(ds, MIME"text/javascript"(); pluto = true)
    s_out = to_string(ds, MIME"text/javascript"(); pluto = false)
    @test contains(s_in, r"JS Listeners .* PlutoExtras") === true
    @test contains(s_out, r"JS Listeners .* PlutoExtras") === false # The listeners where only added in Pluto
    hs_in = to_string(ds, MIME"text/html"(); pluto = true)
    hs_out = to_string(ds, MIME"text/html"(); pluto = false)
    @test contains(hs_in, "<script id='custom_id'>") === true
    @test contains(hs_out, "<script id='custom_id'>") === true

    # Test error with print_script
    @test_throws "Interpolation of `Script` subtypes is not allowed" HypertextLiteral.print_script(IOBuffer(), ds)
    # Test error with show javascript ShowWithPrintHTML
    @test_throws "not supposed to be shown with mime 'text/javascript'" show(IOBuffer(), MIME"text/javascript"(), make_html("asd"))
    # Test error when trying to print invalidation of a NormalScript
    pts = PrintToScript(NormalScript("lol"))
    @test_throws "can't print invalidation" print_javascript(IOBuffer(), pts; pluto = false, kind = :invalidation)
    # Test that print_javascript goes to Base.show with mime text/javascript by default
    @test_throws r"matching show\(.*::Missing" print_javascript(IOBuffer(), missing)
    # Test that print_javascript goes to Base.show with mime text/javascript by default
    @test_throws r"matching show\(.*::Missing" print_html(IOBuffer(), missing)
    # Test that to_string only supports text/html and text/javascript
    @test_throws "Unsupported mime" to_string(1, MIME"text/plain"())

    n = NormalNode("asd")
    # Test that interpolation of nodes in @htl works
    r = @htl("$n")
    s = to_string(r, MIME"text/html"(); pluto = false)
    @test contains(s, "asd")

    cn = make_node([n])
    s = to_string(cn, MIME"text/html"(); pluto = false)
    @test contains(s, "asd")

    # Test that interpolation of ScriptContent inside @htl <script> tags work 
    sc = ScriptContent("asd")
    r = @htl("<script>$([sc])</script>")
    s = to_string(r, MIME"text/html"())
    @test contains(s, "<script>asd")

    # Show outside Pluto
    # PlutoScript should be empty when shown out of Pluto
    n = PlutoScript("asd")
    s_in = to_string(n, MIME"text/html"(); pluto = true)
    s_out = to_string(n, MIME"text/html"(); pluto = false)
    @test contains(s_in, "script id='") === true
    @test isempty(s_out)
    @test contains(string(formatted_code(n)), "```html\n<script id='")

    # ScriptContent should just show as repr outside of Pluto
    sc = ScriptContent("asd")
    s_in = formatted_code(sc; pluto = true) |> string
    s_out = formatted_code(sc; pluto = false) |> string
    @test contains(s_in, "```js\nasd\n") # This is language-js
    @test s_out === s_in # The pluto kwarg is ignored for script content when shown to text/html

    # DualScript
    n = DualScript("asd", "lol"; id = "asd")
    s_in = to_string(n, MIME"text/html"(); pluto = true)
    s_out = to_string(n, MIME"text/html"(); pluto = false)
    @test contains(s_in, "script id='asd'") === true
    @test contains(s_out, "script id='asd'") === true
    @test contains(string(formatted_code(n; pluto=true)), "```html\n<script id='asd'")
    @test add_pluto_compat(n) === true
    @test contains(s_out, LOCAL_MODULE_URL[])
    @test contains(s_out, "async (currentScript) =>") # Opening async outside Pluto
    @test contains(s_out, "})(document.currentScript)") # Closing and calling async outside Pluto
    # Test when Pluto compat is false
    n = DualScript(n; add_pluto_compat = false)
    @test add_pluto_compat(n) === false
    s_out = to_string(n, MIME"text/html"(); pluto = false)
    @test contains(s_out, LOCAL_MODULE_URL[]) === false
    # Test the return
    n = DualScript(PlutoScript(;returned_element = "asd"), NormalScript(;returned_element = "lol"))
    s_in = to_string(n, MIME"text/html"(); pluto = true)
    s_out = to_string(n, MIME"text/html"(); pluto = false)
    @test contains(s_in, "return asd")
    @test contains(s_out, "currentScript.insertAdjacentElement('beforebegin', lol)")

    # NormalNode should be empty when shown out of Pluto
    n = NormalNode("asd")
    s_in = to_string(n, MIME"text/html"(); pluto = true)
    s_out = to_string(n, MIME"text/html"(); pluto = false)
    @test isempty(s_in) === true
    @test s_out === "asd\n"

    ds = DualScript("addScriptEventListeners(asd)", "lol"; id = "asd") # Forcing same id is necessary for equality
    for mime in (MIME"text/javascript"(), MIME"text/html"())
        @test formatted_code(mime)(ds) == formatted_code(ds, mime)
    end
    @test formatted_contents()(ds) == formatted_code(ds; only_contents = true)
    mime = MIME"text/html"()
    for l in (InsidePluto(), OutsidePluto())
        @test formatted_contents(l)(ds) != formatted_code(l; only_contents = false)
    end

    @test formatted_code(ds) == formatted_code(ds, MIME"text/html"())
    sc = ScriptContent("asd")
    @test formatted_code(sc) == formatted_code(sc, MIME"text/javascript"())
    s = let
        io = IOBuffer()
        show(io, MIME"text/html"(), sc)
        String(take!(io))
    end
    @test contains(s, "<div class=\"markdown\"")
    s = let
        io = IOBuffer()
        n = NormalNode("lol")
        show(io, MIME"text/html"(), n)
        String(take!(io))
    end
    @test contains(s, "lol")

    # We test PrintToScript and ShowWithPrintHTML with io accepting functions
    pts = PrintToScript((io; pluto, kwargs...) -> let # We wrap everything in an async call as we want to use await
        write(io, pluto ? "PLUTO" : "NONPLUTO")
    end)
    s_in = to_string(pts, print_javascript; pluto = true)
    s_out = to_string(pts, print_javascript; pluto = false)
    @test s_in === "PLUTO"
    @test s_out === "NONPLUTO"

    swph = ShowWithPrintHTML((io; pluto, kwargs...) -> let # We wrap everything in an async call as we want to use await
        write(io, pluto ? "PLUTO" : "NONPLUTO")
    end)
    s_in = to_string(swph, print_html; pluto = true)
    s_out = to_string(swph, print_html; pluto = false)
    @test s_in === "PLUTO"
    @test s_out === "NONPLUTO"

    # We test print_javascript for dicts
    d = Dict("asd" => "lol")
    s_in = to_string(d, print_javascript; pluto = true) 
    s_out = to_string(d, print_javascript; pluto = false)
    @test contains(s_in, "published object on Pluto")
    @test s_out === """{"asd": "lol"}""" 

    # We test print_javascript for vectors
    v = ["asd", "lol"]
    s_in = to_string(v, print_javascript; pluto = true) 
    s_out = to_string(v, print_javascript; pluto = false)
    @test contains(s_in, "published object on Pluto")
    @test s_out === """["asd", "lol"]""" 
end