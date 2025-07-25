using System.IO;
using System.Text.Json;
using Azure.Core.Serialization;
using Microsoft.Azure.Cosmos;

namespace altgraph_shared_app.Services.Graph.v2
{
  /// <summary>
  /// Uses <see cref="Azure.Core.Serialization.JsonObjectSerializer"/> which leverages System.Text.Json providing a simple API to interact with on the Azure SDKs.
  /// </summary>
  // <SystemTextJsonSerializer>
  public class CosmosSystemTextJsonSerializer : CosmosSerializer
  {
    private readonly JsonObjectSerializer systemTextJsonSerializer;

    public CosmosSystemTextJsonSerializer(JsonSerializerOptions jsonSerializerOptions)
    {
      this.systemTextJsonSerializer = new JsonObjectSerializer(jsonSerializerOptions);
    }
#nullable disable
    public override T FromStream<T>(Stream stream)
    {
      using (stream)
      {
        if (stream.CanSeek
               && stream.Length == 0)
        {
          return default;
        }

        if (typeof(Stream).IsAssignableFrom(typeof(T)))
        {
          return (T)(object)stream;
        }

        return (T)this.systemTextJsonSerializer.Deserialize(stream, typeof(T), default);
      }
    }
#nullable enable
    public override Stream ToStream<T>(T input)
    {
      MemoryStream streamPayload = new MemoryStream();
      this.systemTextJsonSerializer.Serialize(streamPayload, input, input.GetType(), default);
      streamPayload.Position = 0;
      return streamPayload;
    }
  }
  // </SystemTextJsonSerializer>
}