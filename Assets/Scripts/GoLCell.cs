using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GoLCell : MonoBehaviour
{
    
    // Start is called before the first frame update
    void Start()
    {
        AddToGrid();
    }
    
    public void AddToGrid()
    {
        foreach (Transform child in transform)
        {
            int roundedX = Mathf.RoundToInt(child.transform.position.x);
            int roundedY = Mathf.RoundToInt(child.transform.position.y);

            GliderMovement.grid[roundedX, roundedY] = transform;
            //Debug.Log("ADDED AT " + roundedX + " " + roundedY );
        }

        this.enabled = false;
    }
}
