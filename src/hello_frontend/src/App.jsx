import { useState } from 'react';
import { hello_backend } from 'declarations/hello_backend';

function App() {
  const [greeting, setGreeting] = useState('');
  const [getstarter, setGetstarter] = useState('');
  const [walk, setWalk] = useState('');

  function handleSubmit(event) {
    event.preventDefault();
    const name = event.target.elements.name.value;
    hello_backend.greet(name).then((greeting) => {
      setGreeting(greeting);
    });
    return false;
  }

  function handleGetStarter(event){
    event.preventDefault();
    hello_backend.getStarter().then((getstarter) => {setGetstarter(getstarter)});
    return false;
  }

  function handleWalk(event){
    event.preventDefault();
    hello_backend.walkInWild().then((walk) => {setWalk(walk)});
    return false;
  }

  const [attack, setAttack] = useState('');

  function handleAttack(event){
    event.preventDefault();
    hello_backend.attack().then((attack) => {setAttack(attack)});
    return false;
  }

  const [pokecenter, setPokecenter] = useState('');

  function handlePokecenter(event){
    event.preventDefault();
    hello_backend.visitPokeCenter().then((pokecenter) => {setPokecenter(pokecenter)});
    return false;
  }

  const [pokeball, setPokeball] = useState('');

  function handlePokeball(event){
    event.preventDefault();
    hello_backend.throwPokeBall().then((pokeball) => {setPokeball(pokeball)});
    return false;
  }

  const [change, setChange] = useState('');

  function handleChange(event){
    event.preventDefault();
    const number = parseInt(event.target.elements.id.value, 10);
    hello_backend.changePokemon(BigInt(number)).then((change) => {setChange(change)});
    return false;
  }

  const [listall, setlistall] = useState('');

  function handlelistall(event){
    event.preventDefault();
    hello_backend.listAllPokemons().then((listall) => {setlistall(listall)});
    return false;
  }

  const [listmine, setlistmine] = useState('');

  function handlelistmine(event){
    event.preventDefault();
    hello_backend.listOwnedPokemons().then((listmine) => {setlistmine(listmine)});
    return false;
  }

  return (
    <main>
      <img src="/images.png" alt="pokemon logo" />
      <br />

      <form action="#" onSubmit={handleGetStarter}>
        <button type="submit">Get Starter!</button>
      </form>
      <section id="greeting">{getstarter}</section>

      <form action="#" onSubmit={handleWalk}>
        <button type="submit">Walk in the wild!</button>
      </form>
      <section id="greeting">{walk}</section>
      
      <form action="#" onSubmit={handleAttack}>
        <button type="submit">Attack!</button>
      </form>
      <section id="greeting">{attack}</section>
      
      <form action="#" onSubmit={handlePokecenter}>
        <button type="submit">Visit Pokecenter!</button>
      </form>
      <section id="greeting">{pokecenter}</section>

      <form action="#" onSubmit={handlePokeball}>
        <button type="submit">Throw pokeball!</button>
      </form>
      <section id="greeting">{pokeball}</section>

      <form action="#" onSubmit={handlelistmine}>
        <button type="submit">List my pokemon!</button>
      </form>
      <section id="greeting">{listmine}</section>
      <br />
      <br />
      <br />

      <form action="#" onSubmit={handleChange}>
        <label htmlFor="name">Pokemon ID: &nbsp;</label>
        <input id="id" alt="Name" type="text" />
        <button type="submit">Change Pokemon!</button>
      </form>
      <section id="greeting">{change}</section>
      <br />
      <br />
      <br />

      <form action="#" onSubmit={handlelistall}>
        <button type="submit">List all pokemon!</button>
      </form>
      <section id="greeting">{listall}</section>



    </main>
  );
}

export default App;
