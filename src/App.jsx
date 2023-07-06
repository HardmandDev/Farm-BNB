import { useState } from 'react'
import reactLogo from './assets/react.svg'
import viteLogo from '/vite.svg'
import './App.css'

import { ethers } from 'ethers'
import contractABI from './SmartContract/ABI.json'

const contractAddress = '0x12B058a406a9C2214F62Ffa9bFF6b1c370446293' //300 BSC -- 293 MUMBAI

const loadData = async () => {
    const provider = new ethers.BrowserProvider(window.ethereum)
    const contract = new ethers.Contract(contractAddress, contractABI, provider)
    const balance = await contract.getBalance()
    alert(balance)
}


function App() {
  const [count, setCount] = useState(0)

  return (
    <>
      <div>
        <a href="https://vitejs.dev" target="_blank" rel="noreferrer">
          <img src={viteLogo} className="logo" alt="Vite logo" />
        </a>
        <a href="https://react.dev" target="_blank" rel="noreferrer">
          <img src={reactLogo} className="logo react" alt="React logo" />
        </a>
      </div>
      <h1>Vite + React</h1>
      <div className="card">
        <button onClick={() => setCount((count) => count + 1)}>
          count is {count}
        </button>
        <p>
          Change <code>src/App.jsx</code> and save to test HMR
        </p>
        <button onClick={loadData}>Click Me</button>
      </div>
      <p className="read-the-docs">
        Click on the Vite and React logos to learn more
      </p>
    </>
  )
}

export default App
