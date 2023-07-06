// import React from 'react'
import { ethers } from 'ethers'
import contractABI from './ABI.json'

const contractAddress = '0x12B058a406a9C2214F62Ffa9bFF6b1c370446293' //300 BSC -- 293 MUMBAI

const loadData = async () => {
    const provider = new ethers.BrowserProvider(window.ethereum)
    const contract = new ethers.Contract(contractAddress, contractABI, provider)
    const balance = await contract.getBalance()
    alert(balance)
}

let signer = null

let provider

if (window.ethereum == null) {
  alert('Please install MetaMask')
  provider = ethers.getDefaultProvider()

} else {
  provider = new ethers.BrowserProvider(window.ethereum)

  signer = await provider.getSigner()
  console.log(signer)
}

function Contrato() {
    return <button onClick={loadData}>Click Me for Balance on Mumbai</button>
}

export default Contrato