import { useEffect, useState } from "react";
import { ethers } from "ethers";
import contractABI from "../ABI.json";

const contractAddress = "0x12B058a406a9C2214F62Ffa9bFF6b1c370446293";

const TotalBalance = () => {
  const [totalBalance, setTotalBalance] = useState('');
  const [myEggs, setMyEggs] = useState('');
  const [marketEggs, setMarketEggs] = useState('');
  const [actualBalance, setActualBalance] = useState('');


  const loadData = async (method, setState) => {
    const provider = new ethers.BrowserProvider(window.ethereum);
    const contract = new ethers.Contract(contractAddress, contractABI, provider);
    const data = await contract[method]();
    setState(data.toString());
  };

  useEffect(() => {
    loadData("getTotalBalance", setTotalBalance);

    const intervalId = setInterval(() => {
      loadData("getTotalBalance", setTotalBalance);
    }, 30000);

    return () => {
      clearInterval(intervalId);
    };
  }, []);

  useEffect(() => {
    loadData("getMyEggs", setMyEggs);

    const intervalId = setInterval(() => {
      loadData("getMyEggs", setMyEggs);
    }, 3000);

    return () => {
      clearInterval(intervalId);
    };
  }, []);

  useEffect(() => {
    loadData("marketEggs", setMarketEggs);

    const intervalId = setInterval(() => {
      loadData("marketEggs", setMarketEggs);
    }, 3000);

    return () => {
      clearInterval(intervalId);
    };
  }, []);

  useEffect(() => {
    loadData("getBalance", setActualBalance);

    const intervalId = setInterval(() => {
      loadData("getBalance", setActualBalance);
    }, 3000);

    return () => {
      clearInterval(intervalId);
    }
  }, []);

  return (
    <div>
      <button className='btn btn-primary my-5' onClick={() => loadData("getTotalBalance", setTotalBalance)}>Click me option2</button>
      <div>Total Balance: {totalBalance}</div>
      <div>My Eggs: {myEggs}</div>
      <div>Market Eggs: {marketEggs}</div>
      <div>Actual Balance: {actualBalance}</div>
    </div>
  );
};

export default TotalBalance;
