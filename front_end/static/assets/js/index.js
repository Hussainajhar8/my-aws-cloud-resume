const counter = document.querySelector(".counter-number");
async function updateCounter() {
    let response = await fetch(
        "https://lnrigcloeuhotoxa4df7opiwwy0oavww.lambda-url.us-east-1.on.aws/"
    );
    let data = await response.json();
    counter.innerHTML = `You are visitor number: ${data}`;
}
updateCounter();