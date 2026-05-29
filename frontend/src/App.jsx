import { useEffect, useState } from 'react'

const API_URL = import.meta.env.VITE_API_URL ?? 'http://localhost:8080'

export default function App() {
  const [health, setHealth] = useState(null)
  const [error, setError] = useState(null)

  useEffect(() => {
    fetch(`${API_URL}/api/v1/health`)
      .then((r) => r.json())
      .then(setHealth)
      .catch((e) => setError(e.message))
  }, [])

  return (
    <div style={{ fontFamily: 'sans-serif', padding: '2rem' }}>
      <h1>観酒覧</h1>
      <p>Kanshuran</p>
      <hr />
      <h2>API Health</h2>
      {error && <p style={{ color: 'red' }}>Error: {error}</p>}
      {health && <pre>{JSON.stringify(health, null, 2)}</pre>}
      {!health && !error && <p>checking...</p>}
    </div>
  )
}
