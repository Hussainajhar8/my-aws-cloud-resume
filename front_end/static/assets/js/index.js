const counter = document.querySelector(".counter-number");
async function updateCounter() {
    let response = await fetch(
        "https://lambda.ajharresume.com/"
    );
    let data = await response.json();
    counter.innerHTML = `You are visitor number: ${data}`;
}
updateCounter();