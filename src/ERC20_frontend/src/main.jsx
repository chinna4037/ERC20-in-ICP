import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './App';
import './index.scss';
import { AuthClient } from '@dfinity/auth-client'; 
import { idlFactory as ERC20IdlFactory,canisterId} from '../../declarations/ERC20_backend';
import { Actor,HttpAgent } from '@dfinity/agent';
import { Principal } from '@dfinity/principal';


(async()=>{
  const authClient = await AuthClient.create();
  authClient.login({
    maxTimeToLive: BigInt(7 * 24 * 60 * 60 * 1000 * 1000 * 1000), 
    onSuccess: async () => {
      handleAuth(authClient);
    },
    onError: (error) => {
      console.error("Authentication failed:", error);
    }
  });
})();

const handleAuth= (authClient) => {
  const identity = authClient.getIdentity(); 
  console.log("Authenticated Principal:", identity.getPrincipal().toString());
  const agent=new HttpAgent({
    identity,
    // host: "http://localhost:3000",
  });
  const authenticatedCanister=Actor.createActor(ERC20IdlFactory,{
    agent,
    canisterId:canisterId
  });

  render(authenticatedCanister);
};


// const authenticate = () => {
//   authClient.login({
//     maxTimeToLive: BigInt(7 * 24 * 60 * 60 * 1000 * 1000 * 1000), 
//     onSuccess: async () => {
//       handleAuth(authClient);
//     },
//     onError: (error) => {
//       console.error("Authentication failed:", error);
//     }
//   });
// };

function render(authenticatedCanister) {
  ReactDOM.createRoot(document.getElementById('root')).render(
    <React.StrictMode>
      <App authenticatedCanister={authenticatedCanister}/>
    </React.StrictMode>
  );
}



