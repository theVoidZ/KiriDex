using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UIElements;

public class GradualDissolve : MonoBehaviour
{
    private Renderer renderer;
    private bool isDissolving = false;
    private float fade = 1f;
    private void Start()
    {
        renderer = GetComponent<Renderer>();
    }

    private void Update()
    {
        if (isDissolving)
        {
            fade -= Time.deltaTime;

            if (fade <= 0f)
            {
                fade = 0f;
                isDissolving = false;
            }
            
            renderer.material.SetFloat("_Fade", fade );
        }
    }

    public void StartDissolving()
    {
        isDissolving = true;
    }
}
