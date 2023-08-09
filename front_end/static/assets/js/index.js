const counter = document.querySelector(".counter-number");
async function updateCounter() {
    let response = await fetch(
        "https://holsnkc7anu7gjp4puw3muozoi0umvch.lambda-url.us-east-1.on.aws/"
    );
    let data = await response.json();
    counter.innerHTML = `You are visitor number: ${data}`;
}
updateCounter();