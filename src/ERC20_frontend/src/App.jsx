import { useState } from 'react';
import { ERC20_backend ,createActor,canisterId} from 'declarations/ERC20_backend';
import { AuthClient } from '@dfinity/auth-client';

function App({authenticatedCanister}) {
  const [greeting, setGreeting] = useState('');

  async function handleSubmit(event) {
    event.preventDefault();

    authenticatedCanister.whoami().then((greeting) => {
      setGreeting(greeting.toString());
    });
    return false;
  }

  return (
    <main>
      <img src="/logo2.svg" alt="DFINITY logo" />
      <br />
      <br />
      <form action="#" onSubmit={handleSubmit}>
        <label htmlFor="name">Enter your name: &nbsp;</label>
        <input id="name" alt="Name" type="text" />
        <button type="submit">Click Me!</button>
      </form>
      <section id="greeting">{greeting}</section>
    </main>
  );
}

export default App;
