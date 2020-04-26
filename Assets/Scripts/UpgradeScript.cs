using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UIElements;

public class UpgradeScript : MonoBehaviour
{
    public GameObject mapForeground;
    public GameObject mapBackground;
    public GameObject Player;
    public GameObject[] Others;

    // materials
    public Material blackColor;
    public Material grayColor;


    private int availablePoints = 10;
    
    
    private int graphicsLevel = 0;
    private int graphicsLevelMax = 4;
    
    public void UpgradeGraphics()
    {
        if (graphicsLevel < graphicsLevelMax && availablePoints > 0 )
        {
            graphicsLevel++;
            if (graphicsLevel == 1)
            {
                GraphicsLevelOne();
            }
        }
    }

    private void GraphicsLevelOne()
    {
        Player.GetComponent<SpriteRenderer>().sharedMaterial = blackColor;
    }
}
