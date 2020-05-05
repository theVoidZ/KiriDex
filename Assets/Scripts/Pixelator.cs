using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Pixelator : MonoBehaviour
{
    public float inAirValue = 0.96f;
    public float onGroundValue = 0.7f;
    private Renderer renderer;
    private VrtualGuyMovement virtualGuyMovement;
    
    // Start is called before the first frame update
    void Start()
    {
        renderer = GetComponent<Renderer>();
        virtualGuyMovement = GetComponent<VrtualGuyMovement>();
    }

    // Update is called once per frame
    void Update()
    {
        if (virtualGuyMovement.onGround)
        {
            renderer.sharedMaterial.SetFloat("_PixelatedAmount", onGroundValue);
        }

        if (virtualGuyMovement.inAir)
        {
            renderer.sharedMaterial.SetFloat("_PixelatedAmount", inAirValue);
        }
    }
}
