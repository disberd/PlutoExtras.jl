struct SelectHTML
    options::Vector
    default::Int
    classes::Vector{String}
end

SelectHTML(options; default = 1, classes = String[]) = SelectHTML(options, default, classes)

function Base.show(io::IO, mime::MIME"text/html", s::SelectHTML)
    result = @htl("""
    <select-html class=$(s.classes)>
        <div class="options-container">
            $(map(enumerate(s.options)) do (i, opt)
                @htl("""
                <div class='option' data-value=$i>
                    $opt
                </div>
                """)
            end)
            <span class="arrow">▼</span>
        </div>
    </select-html>

    <style>
        select-html {
            width: 300px;
            cursor: pointer;
        }
        
        .options-container {
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 6px;
            background: white;
            position: relative;
        }
        
        .option {
            padding: 12px;
            border-bottom: 1px solid #eee;
            display: none;
        }
        
        .option:first-child {
            display: block;
            border-bottom: none;
        }
        
        .option.selected {
            display: block;
            order: -1;
        }
        
        select-html.open .option {
            display: block;
            position: fixed;
            background: white;
            border: 1px solid #ddd;
            border-radius: 6px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            width: calc(100% - 24px);
            margin: 0;
            z-index: 1000;
        }
        
        select-html.open .option.selected {
            border-bottom: 1px solid #eee;
        }
        
        .arrow {
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            transition: transform 0.2s;
        }
        
        select-html.open .arrow {
            transform: translateY(-50%) rotate(180deg);
        }
        
        .option:hover {
            background-color: #f5f5f5;
        }
    </style>

    <script src="https://cdn.jsdelivr.net/npm/@floating-ui/dom@1.5.1"></script>
    <script>
        const select = document.querySelector('select-html')
        const container = select.querySelector('.options-container')
        const options = select.querySelectorAll('.option')
        
        let cleanup = null;
        
        // Function to update selection
        function updateSelection(option) {
            options.forEach(opt => opt.classList.remove('selected'))
            option.classList.add('selected')
        }
        
        // Add custom property getter/setter
        Object.defineProperty(select, 'value', {
            get: function() {
                const selectedOption = select.querySelector('.option.selected')
                return selectedOption ? selectedOption.dataset.value : null
            },
            set: function(newValue) {
                const option = select.querySelector(`.option[data-value="\${newValue}"]`)
                if (option) {
                    updateSelection(option)
                }
            }
        })
        
        container.onclick = () => {
            if (select.classList.contains('open')) {
                select.classList.remove('open')
                if (cleanup) {
                    cleanup()
                    cleanup = null
                }
            } else {
                select.classList.add('open')
                
                // Use Floating UI to position the options
                cleanup = computePosition(container, options[0], {
                    placement: 'bottom-start',
                    middleware: [
                        offset(4),
                        flip(),
                        shift()
                    ]
                }).then(({x, y}) => {
                    options.forEach(option => {
                        Object.assign(option.style, {
                            left: `\${x}px`,
                            top: `\${y + (option.classList.contains('selected') ? 0 : option.offsetHeight)}px`
                        })
                    })
                })
            }
        }
        
        options.forEach(option => {
            option.onclick = (e) => {
                e.stopPropagation()
                updateSelection(option)
                select.classList.remove('open')
                if (cleanup) {
                    cleanup()
                    cleanup = null
                }
                
                // Dispatch custom input event with the selected value
                const event = new CustomEvent('input', {
                    detail: { value: select.value }
                })
                select.dispatchEvent(event)
                console.log('Selected value:', select.value)
            }
        })
        
        document.addEventListener('click', (e) => {
            if (!select.contains(e.target)) {
                select.classList.remove('open')
                if (cleanup) {
                    cleanup()
                    cleanup = null
                }
            }
        })
    </script>
    """)
    show(io, mime, result)
end