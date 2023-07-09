import './App.css'


import NavbarMenu from './Components/Navbar/NavbarMenu'
import Unity from './SmartContract/Unity'
import _totalBalance from './SmartContract/functionsQuery/query'
import { W3mQrCode } from '@web3modal/react'

function App() {

  return (
    <div className='container-md'>
      <header>
          <NavbarMenu/>        
      </header>
      <h1>Farm BNB</h1>
      <W3mQrCode size={200} imageUrl="https://wiki.polygon.technology/img/polygon-logo.png" uri="data" />
        <Unity />
        {/* <button onClick={loadData}>Click Me for Balance on Mumbai</button> */}
        <_totalBalance />
    </div>
  );
}

export default App
