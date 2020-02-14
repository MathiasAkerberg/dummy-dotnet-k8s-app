FROM mcr.microsoft.com/dotnet/core/aspnet:3.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/core/sdk:3.0 AS build
WORKDIR /src
COPY ["test-docker-debug-vscode.csproj", "./"]
RUN dotnet restore "./test-docker-debug-vscode.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "test-docker-debug-vscode.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "test-docker-debug-vscode.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "test-docker-debug-vscode.dll"]
