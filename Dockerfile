FROM mcr.microsoft.com/dotnet/aspnet:8.0-alpine AS base
ARG buildtime_variable=default_value
ENV ASPNETCORE_HTTP_PORTS=8000
WORKDIR /app
EXPOSE 8000

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["HealthCheckService.csproj", "HealthCheckService/"]
RUN dotnet restore "./HealthCheckService/HealthCheckService.csproj"

WORKDIR "/src/HealthCheckService"
COPY . .

RUN dotnet build "./HealthCheckService.csproj" -c $BUILD_CONFIGURATION -o /app/build 

FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "./HealthCheckService.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false 

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "HealthCheckService.dll"]