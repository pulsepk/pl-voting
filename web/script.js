
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
            // Clear any existing content in the radio buttons div
            radioButtonsDiv.innerHTML = '';

            // Loop through the candidates and create radio buttons
            candidates.forEach((candidate, index) => {
                const candidateName = candidate.name;
                const candidateParty = candidate.party;
                // Create a radio button element
                const radioDiv = document.createElement('div');
                const radioButton = document.createElement('input');
                radioButton.type = 'radio';
                radioButton.name = 'candidateName'; // Set the same name for all radio buttons in the form
                radioButton.value = `${candidateName},${candidateParty}`;
                radioButton.id = `candidateRadio${index}`;

                // Create a label for the radio button
                const label = document.createElement('label');
                label.htmlFor = `candidateRadio${index}`;
                label.textContent = `Select ${candidateName} (${candidateParty})`;

                // Append the radio button and label to the radio buttons div
                radioButtonsDiv.appendChild(label);
                radioButtonsDiv.appendChild(radioButton);
                radioButtonsDiv.appendChild(radioDiv);
                const radioButtonContainer = document.getElementById('radioButtons');

                // Select all radio buttons within the container
                const radioButtons = radioButtonContainer.querySelectorAll('input[type="radio"]');

                // Apply styles to each radio button
                radioButtons.forEach((radioButton) => {
                // Apply your custom CSS styles
                radioButton.style.marginTop = '15px';
                });
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
            .then((response) => {
              
            })
            .catch((error) => {
                console.error(error); 
            });
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
