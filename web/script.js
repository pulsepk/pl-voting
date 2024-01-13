
window.addEventListener("message", (event) => {
    var data = event.data;

    if (data.type === "show_ui") {
        document.getElementById("ui").style.display = "block";
    }
    else if (data.type === "ShowUiAdmin") {
        document.getElementById("admin").style.display = "block";
    }
    else if (data.type === "updateCandidates") {
        const candidates = data.candidates;
        const radioButtonsDiv = document.getElementById('radioButtons');

        if (radioButtonsDiv) {
    radioButtonsDiv.innerHTML = ''; // Clear any existing content

    candidates.forEach((candidate, index) => {
        const radioContainer = document.createElement('div');
        radioContainer.classList.add('radio-option');
        radioContainer.className = 'radio-container';

        const radioButton = document.createElement('input');
        radioButton.type = 'radio';
        radioButton.name = 'candidateName';
        radioButton.value = `${candidate.name},${candidate.party}`;
        radioButton.id = `candidateRadio${index}`;
        radioButton.style.marginTop = '15px';

        const label = document.createElement('label');
        label.htmlFor = `candidateRadio${index}`;
        label.textContent = `Select ${candidate.name} (${candidate.party})`;

        radioContainer.appendChild(radioButton);
        radioContainer.appendChild(label);

        radioButtonsDiv.appendChild(radioContainer);
    });
}

    }
});


document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('myForm');
    const storedData = [];
    const storedParty = []; // Add a variable to store the party
    form.addEventListener('submit', function(e) {
        e.preventDefault();
        storedData.length = 0;
        storedParty.length = 0;
        const formData = new FormData(form);
        const selectedCandidate = formData.get('candidateName');
  
        if (selectedCandidate) {
            const [candidateName, candidateParty] = selectedCandidate.split(',');
            storedData.push(candidateName);
            storedParty.push(candidateParty);
            // Clear the form input (optional)
            form.reset();
            const postData = {
                vote: storedData[0],
                party: storedParty[0]
            };
            axios.post(`https://${GetParentResourceName()}/votesubmit`, postData)
            
        document.getElementById("ui").style.display = "none";
        
        axios.post(`https://${GetParentResourceName()}/hideFrame`)
        }
    });
    const resultsButton = document.getElementById('resultsButton');

    // Add a click event listener to the Results button
    resultsButton.addEventListener('click', function() {
        axios.post(`https://${GetParentResourceName()}/Results`, {});
    });
    window.addEventListener("message", (event) => {
        const data = event.data;
    
        if (data.type === "result") {
            const results = data.results;
    
            // Get the table body element
            const tableBody = document.querySelector("#resultsTable tbody");
    
            // Clear existing table rows
            tableBody.innerHTML = "";
    
            // Iterate through the results and add rows to the table
            results.forEach((result) => {
                const { name, party,votes } = result;
                
                const row = document.createElement("tr");
                row.innerHTML = `
                    <td>${name}</td>
                    <td>${party}</td>
                    <td>${votes}</td>
                `;
                tableBody.appendChild(row);
            });
            document.getElementById("admin").style.display = "none";
            document.getElementById("result").style.display = "block";  
        }
    });
    
});




document.addEventListener("keydown", function(event) {
    if (event.key === "Escape") {
        document.getElementById("ui").style.display = "none";
        document.getElementById("admin").style.display = "none";
        document.getElementById("result").style.display = "none";
        document.getElementById("Resetvote").style.display = "none";
        axios.post(`https://${GetParentResourceName()}/hideFrame`, {})
        .then(function (response) { 
        })
        .catch(function (error) {
        });
    }
});

function deleteRecord() {
    axios.post(`https://${GetParentResourceName()}/deleteRecord`, {})
}
function startelection(){
    axios.post(`https://${GetParentResourceName()}/startelection`, {})
}
function resetvotes(){
    axios.post(`https://${GetParentResourceName()}/resetvotes`, {})
}
function endElection(){
    axios.post(`https://${GetParentResourceName()}/endElection`, {})
}
function resetSomeone(){
    document.getElementById("admin").style.display = "none";
    document.getElementById("Resetvote").style.display = "block";

    const form = document.getElementById("IdForm");
    form.removeEventListener('submit', handleFormSubmit);
    form.addEventListener('submit', handleFormSubmit);
}
function handleFormSubmit(event) {
    event.preventDefault();
    const playerNumber = document.getElementById("playerNumber").value;
    axios.post(`https://${GetParentResourceName()}/resetSomeonevote`, {
        playerNumber: playerNumber
    })
}

function exit(){
    document.getElementById("ui").style.display = "none";  
    document.getElementById("admin").style.display = "none";
    document.getElementById("Resetvote").style.display = "none";
    axios.post(`https://${GetParentResourceName()}/hideFrame`, {})
        .then(function (response) { 
        })
        .catch(function (error) {
        });  
}

function gobackresults(){
    document.getElementById("result").style.display = "none";
    document.getElementById("admin").style.display = "block";
}

function gobackmenu(){
    document.getElementById("Resetvote").style.display = "none";
    document.getElementById("admin").style.display = "block";
}