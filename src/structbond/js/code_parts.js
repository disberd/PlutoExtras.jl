// NEW BLOCK: replace_script_preamble
// This preamble is used to skip
let props = Object.keys(window).filter(function (q) {
  return /FUNCTION_TO_RUN/.test(q);
});
for (const prop of props) {
  const obj = window[prop];
  if (obj === undefined) {
    continue;
  }
  if (obj.currentScript === currentScript) {
    const cell_id = currentScript.closest("pluto-cell").id;
    const script_id = currentScript.id;
    console.log("Saving this script for later execution");
    _.set(window, ["script_to_replace", cell_id, script_id], obj);
    return;
  }
}

// NEW BLOCK: replace_html
// Taken from https://stackoverflow.com/questions/2592092/executing-script-elements-inserted-with-innerhtml
function setInnerHTML(elm, html) {
  elm.innerHTML = html;

  Array.from(elm.querySelectorAll("script")).forEach((oldScriptEl) => {
    const newScriptEl = document.createElement("script");

    Array.from(oldScriptEl.attributes).forEach((attr) => {
      newScriptEl.setAttribute(attr.name, attr.value);
    });

    const scriptText = document.createTextNode(oldScriptEl.innerHTML);
    newScriptEl.appendChild(scriptText);

    oldScriptEl.parentNode.replaceChild(newScriptEl, oldScriptEl);
  });
}

// NEW BLOCK: replace_style
function replaceStyle(name, content, priority = 1) {
  const package_container =
    document.head.querySelector("plutoextras-style") ??
    document.head.insertAdjacentElement(
      "beforeend",
      html`<plutoextras-style></plutoextras-style>`
    );
  const this_container =
    package_container.querySelector(name) ??
    package_container.insertAdjacentElement(
      "beforeend",
      html`<${name}><style></style></${name}>`
    );
  // Assign priority
  this_container.priority = priority;
  // Assign creation time
  this_container.created_at = this_container.created_at ?? Date.now()
  const style_element = this_container.firstElementChild;
  style_element.innerHTML = content;
  // Now we sort the children based on priority, using code from https://stackoverflow.com/a/50127768
  [...package_container.children]
    .sort((a, b) => (a.priority < b.priority ? -1 : a.created_at >= b.created_at ? 1 : -1))
    .forEach((node) => package_container.appendChild(node));
}
