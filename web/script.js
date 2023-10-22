
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

                // Create a radio button element
                const radioButton = document.createElement('input');
                radioButton.type = 'radio';
                radioButton.name = 'candidateName'; // Set the same name for all radio buttons in the form
                radioButton.value = candidateName;
                radioButton.id = `candidateRadio${index}`;

                // Create a label for the radio button
                const label = document.createElement('label');
                label.htmlFor = `candidateRadio${index}`;
                label.textContent = `Select ${candidateName}`;

                // Append the radio button and label to the radio buttons div
                radioButtonsDiv.appendChild(radioButton);
                radioButtonsDiv.appendChild(label);
            });
        }
    }
});
/* addEventListener("message", (event) => {
    var data = event.data;
    if (data.type === "updateCandidates") {
        const candidates = data.candidates;
        const radioButtonsDiv = document.getElementById('radioButtons');

        if (radioButtonsDiv) {
            // Clear any existing content in the radio buttons div
            radioButtonsDiv.innerHTML = '';

            // Loop through the candidates and create radio buttons
            candidates.forEach((candidate, index) => {
                const candidateName = candidate.name;

                // Create a radio button element
                const radioButton = document.createElement('input');
                radioButton.type = 'radio';
                radioButton.name = 'candidateName'; // Set the same name for all radio buttons in the form
                radioButton.value = candidateName;
                radioButton.id = `candidateRadio${index}`;

                // Create a label for the radio button
                const label = document.createElement('label');
                label.htmlFor = `candidateRadio${index}`;
                label.textContent = `Select ${candidateName}`;

                // Append the radio button and label to the radio buttons div
                radioButtonsDiv.appendChild(radioButton);
                radioButtonsDiv.appendChild(label);
            });
        }
    }
}); */

document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('myForm');
    const storedData = [];

    form.addEventListener('submit', function(e) {
        e.preventDefault();
        storedData.length = 0;
        const formData = new FormData(form);
        const selectedCandidate = formData.get('candidateName');

        if (selectedCandidate) {
            storedData.push(selectedCandidate);

            // Clear the form input (optional)
            form.reset();
            const postData = {
                vote: storedData
            };

            // Log the stored data
            
            console.log(storedData.join(', ')); // Log all elements joined by a comma and space
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
                const { name, votes } = result;
                
                const row = document.createElement("tr");
                row.innerHTML = `
                    <td>${name}</td>
                    <td>${votes}</td>
                `;
    
                tableBody.appendChild(row);
            });
            document.getElementById("admin").style.display = "none";
            document.getElementById("result").style.display = "block";
            
        }
    });
    
});

/* document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('myForm');
    const storedDataList = document.getElementById('storedData');
    const storedData = [];

    form.addEventListener('submit', function(e) {
        e.preventDefault();
        const formData = new FormData(form);
        const name = formData.get('name');
        storedData.push(name);
        const storedDataAsString = storedData.join(', '); 
        const postData = {
            vote: storedDataAsString
        };
        
        axios.post(`https://${GetParentResourceName()}/votesubmit`, postData)
            .then((response) => {
              
            })
            .catch((error) => {
                console.error(error); 
            });
        document.getElementById("ui").style.display = "none";
        axios.post(`https://${GetParentResourceName()}/hideFrame`)
    });
    
}); */
/* document.addEventListener('DOMContentLoaded', function() {
window.addEventListener("message", (event) => {
    
    var data = event.data;

    if (data.type === "result") {
        document.getElementById("admin").style.display = "none";
        document.getElementById("result").style.display = "block";

        // Extract the results from the message
        const results = data.results;
        console.log(data.results);

        // Prepare the data for the pie chart
        const labels = results.map((result) => result.name);
        const votes = results.map((result) => result.votes);

        // Generate random background colors for each candidate
        const backgroundColors = results.map(() => getRandomColor());

        const data = {
            labels: labels,
            datasets: [
                {
                    data: votes,
                    backgroundColor: backgroundColors,
                    hoverOffset: 4,
                },
            ],
        };

        const config = {
            type: 'pie',
            data: data,
        };

        const ctx = document.getElementById('pieChart').getContext('2d');
        const myChart = new Chart(ctx, config);
    }
});
}); */

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
function Results(){
    axios.post(`https://${GetParentResourceName()}/Results`, {})
}