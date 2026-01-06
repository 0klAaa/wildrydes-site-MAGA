exports.handler = async (event) => {
  const requestBody = JSON.parse(event.body || "{}");

  const unicorns = [
    "AnaisRainbow",
    "DashDash",
    "Twilight Sparkle",
    "Pinkie Pie",
    "Luna",
    "Celestia"
  ];

  const unicorn = unicorns[Math.floor(Math.random() * unicorns.length)];

  const response = {
    RideId: crypto.randomUUID(),
    Unicorn: unicorn,
    Eta: `${Math.floor(Math.random() * 10) + 1} minutes`,
    Rider: event.requestContext.authorizer?.claims?.email ?? "anonymous"
  };

  return {
    statusCode: 200,
    headers: {
      "Content-Type": "application/json",
      "Access-Control-Allow-Origin": "*"
    },
    body: JSON.stringify(response)
  };
};