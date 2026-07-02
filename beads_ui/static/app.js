// Beads UI — collapsible tree client.

const state = {
  issues: [],
  byId: new Map(),
  children: new Map(),     // parentId -> [childId, ...]
  roots: [],
  collapsed: new Set(),    // node ids that are collapsed
  selected: null,
  query: "",
  statuses: new Set(["open", "in_progress"]),
  types: new Set(["epic", "feature", "task", "bug", "chore"]),
  matchedIds: null,        // null = no query; Set otherwise
};

const $tree = document.getElementById("tree");
const $detail = document.getElementById("detail-body");
const $search = document.getElementById("search");
const $status = document.getElementById("status");
const $back = document.getElementById("back");
const $filterRow = document.getElementById("filter-row");
const $toggleFilters = document.getElementById("toggle-filters");

const isMobile = () => window.matchMedia("(max-width: 760px)").matches;

const STATE_KEY = "beads-ui-state-v1";

function saveState() {
  try {
    localStorage.setItem(STATE_KEY, JSON.stringify({
      query: state.query,
      statuses: [...state.statuses],
      types: [...state.types],
      collapsed: [...state.collapsed],
      selected: state.selected,
      showDetail: document.body.classList.contains("show-detail"),
      scrollTree: $tree.scrollTop || 0,
    }));
  } catch (_) { /* quota / private mode — ignore */ }
}

function loadState() {
  try {
    const raw = localStorage.getItem(STATE_KEY);
    if (!raw) return null;
    return JSON.parse(raw);
  } catch (_) { return null; }
}

function buildIndex(issues) {
  state.issues = issues;
  state.byId.clear();
  state.children.clear();
  for (const it of issues) state.byId.set(it.id, it);

  for (const it of issues) {
    let parent = null;
    for (const d of (it.dependencies || [])) {
      if (d.type === "parent-child" || d.type === "parent") {
        if (d.depends_on_id && d.depends_on_id !== it.id) {
          parent = d.depends_on_id;
          break;
        }
      }
    }
    if (parent && state.byId.has(parent)) {
      if (!state.children.has(parent)) state.children.set(parent, []);
      state.children.get(parent).push(it.id);
    }
  }

  const typeOrder = { epic: 0, feature: 1, task: 2, bug: 3, chore: 4 };
  const sortFn = (a, b) => {
    const ia = state.byId.get(a), ib = state.byId.get(b);
    const ta = typeOrder[ia.issue_type] ?? 9;
    const tb = typeOrder[ib.issue_type] ?? 9;
    if (ta !== tb) return ta - tb;
    const pa = ia.priority ?? 9, pb = ib.priority ?? 9;
    if (pa !== pb) return pa - pb;
    return ia.id.localeCompare(ib.id);
  };
  for (const arr of state.children.values()) arr.sort(sortFn);

  const childIds = new Set();
  for (const arr of state.children.values()) for (const c of arr) childIds.add(c);
  state.roots = issues.map(i => i.id).filter(id => !childIds.has(id)).sort((a, b) => sortFn(a, b));
}

function computeVisible() {
  const q = state.query.trim().toLowerCase();
  const ownPass = new Map();
  for (const it of state.issues) {
    const statusOk = state.statuses.has(it.status);
    const typeOk = state.types.has(it.issue_type);
    let qOk = true;
    if (q) {
      const hay = (it.id + "\n" + (it.title || "") + "\n" + (it.description || "")).toLowerCase();
      qOk = hay.includes(q);
    }
    ownPass.set(it.id, statusOk && typeOk && qOk);
  }
  const subtree = new Map();
  const visit = (id) => {
    if (subtree.has(id)) return subtree.get(id);
    let any = ownPass.get(id) === true;
    const kids = state.children.get(id) || [];
    for (const k of kids) if (visit(k)) any = true;
    subtree.set(id, any);
    return any;
  };
  for (const r of state.roots) visit(r);
  return { ownPass, subtree };
}

function highlight(text, q) {
  if (!q) return escapeHtml(text);
  const safe = escapeHtml(text);
  const re = new RegExp(escapeRegex(q), "ig");
  return safe.replace(re, m => `<mark class="hit">${m}</mark>`);
}

function escapeHtml(s) {
  return String(s).replace(/[&<>"]/g, c => ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;" }[c]));
}
function escapeRegex(s) { return s.replace(/[.*+?^${}()|[\]\\]/g, "\\$&"); }

function renderTree() {
  const { ownPass, subtree } = computeVisible();
  const q = state.query.trim().toLowerCase();
  const frag = document.createDocumentFragment();
  let shown = 0;

  const renderNode = (id, depth) => {
    if (!subtree.get(id)) return null;
    const it = state.byId.get(id);
    const kids = (state.children.get(id) || []).filter(k => subtree.get(k));
    const hasKids = kids.length > 0;
    const collapsed = state.collapsed.has(id);

    const node = document.createElement("div");
    node.className = "node";

    const row = document.createElement("div");
    row.className = "row " + (it.status === "closed" ? "closed " : "") + (state.selected === id ? "selected" : "");
    const indent = isMobile() ? 10 : 14;
    row.style.paddingLeft = (4 + depth * indent) + "px";
    row.dataset.id = id;

    const caret = document.createElement("span");
    caret.className = "caret" + (hasKids ? "" : " empty");
    caret.textContent = hasKids ? (collapsed ? "▶" : "▼") : "•";
    caret.addEventListener("click", (e) => {
      e.stopPropagation();
      if (!hasKids) return;
      if (state.collapsed.has(id)) state.collapsed.delete(id);
      else state.collapsed.add(id);
      renderTree();
      saveState();
    });

    const dot = document.createElement("span");
    dot.className = "statusdot " + it.status;
    dot.title = it.status;

    const type = document.createElement("span");
    type.className = "typebadge " + it.issue_type;
    type.textContent = it.issue_type;

    const prio = document.createElement("span");
    prio.className = "prio p" + (it.priority ?? "");
    prio.textContent = "P" + (it.priority ?? "?");

    const idSpan = document.createElement("span");
    idSpan.className = "id";
    idSpan.innerHTML = highlight(shortId(id), q);

    const title = document.createElement("span");
    title.className = "title";
    title.innerHTML = highlight(it.title || "(untitled)", q);

    row.append(caret, dot, type, prio, idSpan, title);

    if (hasKids) {
      const count = document.createElement("span");
      count.className = "count";
      count.textContent = `(${kids.length})`;
      row.append(count);
    }

    row.addEventListener("click", () => {
      state.selected = id;
      renderDetail(id);
      document.querySelectorAll(".row.selected").forEach(r => r.classList.remove("selected"));
      row.classList.add("selected");
      if (isMobile()) {
        document.body.classList.add("show-detail");
        $detail.parentElement.scrollTop = 0;
      }
      saveState();
    });

    node.append(row);
    shown++;

    if (hasKids) {
      const childrenEl = document.createElement("div");
      childrenEl.className = "children" + (collapsed ? " collapsed" : "");
      for (const k of kids) {
        const ch = renderNode(k, depth + 1);
        if (ch) childrenEl.append(ch);
      }
      node.append(childrenEl);
    }

    return node;
  };

  for (const r of state.roots) {
    const n = renderNode(r, 0);
    if (n) frag.append(n);
  }

  $tree.innerHTML = "";
  $tree.append(frag);
  $status.textContent = `${shown} shown / ${state.issues.length} total`;
}

function shortId(id) {
  const i = id.lastIndexOf("-");
  return i >= 0 ? id.slice(i + 1) : id;
}

function renderDetail(id) {
  const it = state.byId.get(id);
  if (!it) {
    $detail.innerHTML = `<div class="empty">Unknown issue ${escapeHtml(id)}</div>`;
    return;
  }

  const deps = (it.dependencies || []);
  const parent = deps.find(d => d.type === "parent-child" || d.type === "parent");
  const blocks = deps.filter(d => d.type === "blocks");
  const related = deps.filter(d => d.type === "related");

  const dependents = [];
  for (const other of state.issues) {
    for (const d of (other.dependencies || [])) {
      if (d.depends_on_id === id) dependents.push({ id: other.id, type: d.type });
    }
  }

  const childIds = state.children.get(id) || [];
  const linkList = (ids) => ids.length ? `<ul>${ids.map(x => `<li><a href="#" data-go="${escapeHtml(x)}">${escapeHtml(shortId(x))}</a> — ${escapeHtml((state.byId.get(x) || {}).title || "?")}</li>`).join("")}</ul>` : `<div class="empty">none</div>`;

  $detail.innerHTML = `
    <h1>${escapeHtml(it.title || "(untitled)")}</h1>
    <div class="sub">
      <span class="typebadge ${it.issue_type}">${it.issue_type}</span>
      <span><span class="statusdot ${it.status}"></span> ${escapeHtml(it.status)}</span>
      <span>P${it.priority ?? "?"}</span>
      <code>${escapeHtml(it.id)}</code>
      ${it.assignee ? `<span>👤 ${escapeHtml(it.assignee)}</span>` : ""}
      ${it.created_at ? `<span>created ${escapeHtml(it.created_at)}</span>` : ""}
      ${it.updated_at ? `<span>updated ${escapeHtml(it.updated_at)}</span>` : ""}
      ${it.closed_at ? `<span>closed ${escapeHtml(it.closed_at)}</span>` : ""}
    </div>

    ${it.description ? `<section><h2>description</h2><div class="desc">${escapeHtml(it.description)}</div></section>` : ""}
    ${it.close_reason ? `<section><h2>close reason</h2><pre>${escapeHtml(it.close_reason)}</pre></section>` : ""}

    <section class="deps">
      <h2>parent</h2>
      ${parent ? `<ul><li><a href="#" data-go="${escapeHtml(parent.depends_on_id)}">${escapeHtml(shortId(parent.depends_on_id))}</a> — ${escapeHtml((state.byId.get(parent.depends_on_id) || {}).title || "?")}</li></ul>` : `<div class="empty">none (root)</div>`}

      <h2>children (${childIds.length})</h2>
      ${linkList(childIds)}

      <h2>blocks (${blocks.length})</h2>
      ${linkList(blocks.map(b => b.depends_on_id))}

      <h2>related (${related.length})</h2>
      ${linkList(related.map(b => b.depends_on_id))}

      <h2>dependents (${dependents.length})</h2>
      ${dependents.length ? `<ul>${dependents.map(d => `<li><a href="#" data-go="${escapeHtml(d.id)}">${escapeHtml(shortId(d.id))}</a> — ${escapeHtml((state.byId.get(d.id) || {}).title || "?")} <span style="color:var(--fg-faint)">(${escapeHtml(d.type)})</span></li>`).join("")}</ul>` : `<div class="empty">none</div>`}
    </section>
  `;

  $detail.querySelectorAll("a[data-go]").forEach(a => {
    a.addEventListener("click", (e) => {
      e.preventDefault();
      const target = a.dataset.go;
      let cur = target;
      while (cur) {
        const next = parentOf(cur);
        if (next) state.collapsed.delete(next);
        cur = next;
      }
      state.selected = target;
      renderTree();
      renderDetail(target);
      const row = $tree.querySelector(`.row[data-id="${cssEscape(target)}"]`);
      if (row) row.scrollIntoView({ block: "center", behavior: "smooth" });
      saveState();
    });
  });
}

function parentOf(id) {
  const it = state.byId.get(id);
  if (!it) return null;
  for (const d of (it.dependencies || [])) {
    if (d.type === "parent-child" || d.type === "parent") return d.depends_on_id;
  }
  return null;
}

function cssEscape(s) {
  return (window.CSS && CSS.escape) ? CSS.escape(s) : s.replace(/"/g, '\\"');
}

async function reload() {
  $status.textContent = "loading…";
  const r = await fetch("/api/issues");
  if (!r.ok) { $status.textContent = "load failed: " + r.status; return; }
  const data = await r.json();
  buildIndex(data.issues);
  renderTree();
  if (state.selected && state.byId.has(state.selected)) {
    renderDetail(state.selected);
  } else {
    state.selected = null;
  }
  const saved = loadState();
  if (saved && typeof saved.scrollTree === "number") {
    requestAnimationFrame(() => { $tree.scrollTop = saved.scrollTree; });
  }
  saveState();
}

function restoreFromStorage() {
  const saved = loadState();
  if (!saved) return;
  if (typeof saved.query === "string") state.query = saved.query;
  if (Array.isArray(saved.statuses)) state.statuses = new Set(saved.statuses);
  if (Array.isArray(saved.types)) state.types = new Set(saved.types);
  if (Array.isArray(saved.collapsed)) state.collapsed = new Set(saved.collapsed);
  if (typeof saved.selected === "string") state.selected = saved.selected;

  $search.value = state.query || "";
  if (saved.showDetail && isMobile()) document.body.classList.add("show-detail");
}

function bind() {
  $search.addEventListener("input", () => {
    state.query = $search.value;
    if (state.query.trim()) state.collapsed.clear();
    renderTree();
    saveState();
  });

  document.querySelectorAll(".filters input[data-status]").forEach(el => {
    el.checked = state.statuses.has(el.dataset.status);
    el.addEventListener("change", () => {
      if (el.checked) state.statuses.add(el.dataset.status);
      else state.statuses.delete(el.dataset.status);
      renderTree();
      saveState();
    });
  });
  document.querySelectorAll(".filters input[data-type]").forEach(el => {
    el.checked = state.types.has(el.dataset.type);
    el.addEventListener("change", () => {
      if (el.checked) state.types.add(el.dataset.type);
      else state.types.delete(el.dataset.type);
      renderTree();
      saveState();
    });
  });

  document.getElementById("expand-all").addEventListener("click", () => {
    state.collapsed.clear();
    renderTree();
    saveState();
  });
  document.getElementById("collapse-all").addEventListener("click", () => {
    state.collapsed = new Set(state.issues.map(i => i.id));
    renderTree();
    saveState();
  });
  document.getElementById("reload").addEventListener("click", reload);

  $back.addEventListener("click", () => {
    document.body.classList.remove("show-detail");
    saveState();
  });

  $toggleFilters.addEventListener("click", () => {
    const open = $filterRow.classList.toggle("open");
    $toggleFilters.setAttribute("aria-expanded", open ? "true" : "false");
  });

  $tree.addEventListener("scroll", () => {
    if (bind._scrollTimer) clearTimeout(bind._scrollTimer);
    bind._scrollTimer = setTimeout(saveState, 200);
  });

  let lastMobile = isMobile();
  window.addEventListener("resize", () => {
    const m = isMobile();
    if (m !== lastMobile) { lastMobile = m; renderTree(); }
  });
}

restoreFromStorage();
bind();
reload();
