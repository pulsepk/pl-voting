
window.addEventListener("message", (event) => {
    var data = event.data;

    if (data.type === "show_ui") {
        document.getElementById("ui").style.display = "block";
    }
});

window.addEventListener("message", (event) => {
    var data = event.data;

    if (data.type === "ShowUiAdmin") {
        document.getElementById("admin").style.display = "block";
    }
});
window.addEventListener("message", (event) => {
    var data = event.data;
    if (data.type === "updateCandidates") {
        const candidates = data.candidates;
        const candidateNames = candidates.map((candidate) => candidate.name).join(", ");
        const candidateNameInput = document.getElementById('candidateName');
        const candidateNameLabel = document.querySelector('label[for="candidateName"]');
        if (candidateNameInput) {
            candidateNameInput.value = candidateNames;
            console.log(candidateNameInput.value)
        }
        if (candidateNameLabel) {
            candidateNameLabel.textContent = `Select a Candidate: ${candidateNames}`;
        }
    }
});

document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('myForm');
    const storedDataList = document.getElementById('storedData');
    const confirmation = document.getElementById('confirmation');
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
        /* form.style.display = 'none';
        confirmation.style.display = 'block';
        heading.style.display = 'none'; */
    });
    
});

window.addEventListener("message", (event) => {
    var data = event.data;

    if (data.type === "result") {
        document.getElementById("admin").style.display = "none";
        document.getElementById("result").style.display = "block";
        const data = {
            labels: ['Category 1', 'Category 2'],
            datasets: [
                {
                    data: [12, 19], // Replace with your data
                    backgroundColor: [
                        'rgba(255, 99, 132, 0.6)',
                        'rgba(75, 192, 192, 0.6)',
                    ],
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