const API_URL = document.body.dataset.apiUrl;
const form = document.querySelector('#welcome-form');
const greeting = document.querySelector('#greeting');
const counter = document.querySelector('#view-counter');

const fetchCounter = async () => {
  if (!API_URL) {
    counter.textContent = 'Configure API in data-api-url attribute';
    return;
  }

  try {
    const response = await fetch(API_URL, { cache: 'no-store' });
    if (!response.ok) {
      throw new Error(`Unexpected status ${response.status}`);
    }

    const body = await response.json();
    counter.textContent = body.views.toLocaleString();
  } catch (error) {
    console.error('Unable to read counter', error);
    counter.textContent = 'Unable to connect';
  }
};

const handleSubmit = (event) => {
  event.preventDefault();
  const name = form.elements.name.value.trim();
  if (!name) {
    return;
  }
  greeting.textContent = `Hello, ${name}. Views are rising!`;
  form.reset();
};

form.addEventListener('submit', handleSubmit);
setInterval(fetchCounter, 4000);
fetchCounter();