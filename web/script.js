'use strict';

// ── NUI helper — replaces axios with native fetch ─────────────────────────
function postNUI(endpoint, data) {
    return fetch(`https://${GetParentResourceName()}/${endpoint}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data ?? {}),
    }).catch(() => {});
}

// ── Panel management ──────────────────────────────────────────────────────
const PANEL_IDS = ['ui', 'admin', 'deleterecord', 'Resetvote', 'result'];

function showPanel(id) {
    PANEL_IDS.forEach(pid => {
        const el = document.getElementById(pid);
        if (el) el.classList.add('hidden');
    });
    if (id) {
        const el = document.getElementById(id);
        if (el) el.classList.remove('hidden');
    }
}

// ── Medal symbols for top-3 results ──────────────────────────────────────
const MEDALS = ['🥇', '🥈', '🥉'];

// ── NUI message handler ───────────────────────────────────────────────────
window.addEventListener('message', (event) => {
    const data = event.data;
    if (!data || !data.type) return;

    if (data.type === 'show_ui') {
        showPanel('ui');

    } else if (data.type === 'ShowUiAdmin') {
        showPanel('admin');

    } else if (data.type === 'updateCandidates') {
        buildCandidateList(data.candidates || []);

    } else if (data.type === 'result') {
        buildResultsTable(data.results || []);
        showPanel('result');
    }
});

// ── Build candidate cards ─────────────────────────────────────────────────
function buildCandidateList(candidates) {
    const container = document.getElementById('radioButtons');
    if (!container) return;
    container.innerHTML = '';

    candidates.forEach((candidate, index) => {
        // Label acts as the clickable card
        const label = document.createElement('label');
        label.className = 'candidate-card';
        label.htmlFor = `cand_${index}`;

        // Hidden radio keeps standard form behaviour
        const radio = document.createElement('input');
        radio.type      = 'radio';
        radio.className = 'candidate-radio';
        radio.name      = 'candidateName';
        // Use a safe separator that won't appear in names/parties
        radio.value     = `${index}`;
        radio.id        = `cand_${index}`;
        radio.dataset.name  = candidate.name;
        radio.dataset.party = candidate.party;

        radio.addEventListener('change', () => {
            document.querySelectorAll('.candidate-card').forEach(c => c.classList.remove('selected'));
            label.classList.add('selected');
        });

        const info = document.createElement('div');
        info.className = 'candidate-info';

        const nameEl = document.createElement('div');
        nameEl.className = 'candidate-name';
        nameEl.textContent = candidate.name;   // textContent prevents XSS

        const partyEl = document.createElement('div');
        partyEl.className = 'candidate-party';
        partyEl.textContent = candidate.party;

        const badge = document.createElement('div');
        badge.className = 'candidate-badge';
        // Show only the first word of the party name as the badge label
        badge.textContent = candidate.party.split(' ')[0];

        info.appendChild(nameEl);
        info.appendChild(partyEl);

        label.appendChild(radio);
        label.appendChild(info);
        label.appendChild(badge);
        container.appendChild(label);
    });
}

// ── Build results table ───────────────────────────────────────────────────
function buildResultsTable(results) {
    const tbody = document.querySelector('#resultsTable tbody');
    if (!tbody) return;
    tbody.innerHTML = '';

    // Sort highest votes first
    const sorted = [...results].sort((a, b) => Number(b.votes) - Number(a.votes));

    sorted.forEach((result, index) => {
        const row = document.createElement('tr');

        const tdRank = document.createElement('td');
        tdRank.className = 'col-rank';
        tdRank.textContent = index < 3 ? MEDALS[index] : String(index + 1);

        const tdName = document.createElement('td');
        tdName.textContent = result.name;   // textContent prevents XSS

        const tdParty = document.createElement('td');
        tdParty.textContent = result.party;

        const tdVotes = document.createElement('td');
        tdVotes.className = 'col-votes';
        tdVotes.textContent = result.votes;

        row.appendChild(tdRank);
        row.appendChild(tdName);
        row.appendChild(tdParty);
        row.appendChild(tdVotes);
        tbody.appendChild(row);
    });
}

// ── DOMContentLoaded: wire up forms ──────────────────────────────────────
document.addEventListener('DOMContentLoaded', () => {

    // Vote submission form
    const voteForm = document.getElementById('myForm');
    voteForm.addEventListener('submit', (e) => {
        e.preventDefault();
        const selected = voteForm.querySelector('input[name="candidateName"]:checked');
        if (!selected) return;

        const candidateName  = selected.dataset.name;
        const candidateParty = selected.dataset.party;

        postNUI('votesubmit', { vote: candidateName, party: candidateParty });
        voteForm.reset();
        document.querySelectorAll('.candidate-card').forEach(c => c.classList.remove('selected'));
        showPanel(null);
        postNUI('hideFrame');
    });

    // Results button in admin panel
    const resultsBtn = document.getElementById('resultsButton');
    if (resultsBtn) {
        resultsBtn.addEventListener('click', () => postNUI('Results'));
    }
});

// ── Keyboard: Escape closes all panels ───────────────────────────────────
document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') {
        showPanel(null);
        postNUI('hideFrame');
    }
});

// ── Admin actions ─────────────────────────────────────────────────────────
function DeleteConfirm() { showPanel('deleterecord'); }

function deleteRecord() {
    postNUI('deleteRecord');
    showPanel('admin');
}

function startelection() { postNUI('startelection'); }
function resetvotes()    { postNUI('resetvotes');    }
function endElection()   { postNUI('endElection');   }

function resetSomeone() {
    showPanel('Resetvote');

    // Replace the form node to remove any previously-attached listener
    const oldForm = document.getElementById('IdForm');
    const newForm = oldForm.cloneNode(true);
    oldForm.parentNode.replaceChild(newForm, oldForm);

    newForm.addEventListener('submit', (e) => {
        e.preventDefault();
        const playerNumber = document.getElementById('playerNumber').value;
        postNUI('resetSomeonevote', { playerNumber });
        showPanel('admin');
    });
}

// ── Navigation helpers ────────────────────────────────────────────────────
function exit()           { showPanel(null);    postNUI('hideFrame'); }
function gobackresults()  { showPanel('admin'); }
function gobackmenu()     { showPanel('admin'); }
function gobackelection() { showPanel('admin'); }
