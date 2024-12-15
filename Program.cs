var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

app.MapGet("/", () => "Hello World!");
app.MapGet("/health/", () => Results.Json(new { status = "OK" }));

//app.Urls.Add("http://localhost:8000");

app.Run();
