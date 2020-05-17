using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TileItemDrops : MonoBehaviour
{
    public Vector2 blockLocation;

    public void SetLocation(int x, int y)
    {
        blockLocation = new Vector2(x,y);
    }
}
