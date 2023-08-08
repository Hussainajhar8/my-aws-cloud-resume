const counter = document.querySelector(".counter-number");
async function updateCounter() {
    let response = await fetch(
        "https://qd2nwbegmtokeo3f2mjex6azqa0rfvka.lambda-url.us-east-1.on.aws/"
    );
    let data = await response.json();
    counter.innerHTML = `You are visitor number: ${data}`;
}
updateCounter();